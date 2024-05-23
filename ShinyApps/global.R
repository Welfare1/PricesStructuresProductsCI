library(shiny)
library(tidyverse)
library(stringdist)
library(tidygeocoder)
library(sf)
library(plotly)
library(bslib)
library(shiny)
library(plotly)
library(bslib)
library(leaflet)
library(DT)
library(zoo)
library(rAmCharts)
library(sp)
library(shinycssloaders)
library(rvest)
library(lubridate)
library(dygraphs)
library(gt)
library(rmapshaper)
library(shinythemes)
#########################################################################""

### Analyse par Region

dpt <- read_sf("data/civ")
# dpt <- ms_simplify(dpt)
priceGlob <- read.csv("data/priceGlobCleanFull.csv")
VillePaysVilleProche1 <- read_csv("data/VillePaysVilleProche.csv")
adressRegion1 <- read_csv("data/adressRegion.csv")

# Jointure avec la base de données sf des villes de la côte d'ivoire
dpt2 <- left_join(dpt,VillePaysVilleProche1,join_by(ADM3_FR==VillePays))

#Indicateur

priceGlobCleanFull <- priceGlob |>
  group_by(PRODUITS,VILLE) |>
  mutate(PRIXPREC=lag(PRIX,order_by = DATE)) # Dataset de base


# Indicateur_recap
indicateurs_recap<- priceGlobCleanFull |>
  filter(CATEGORIE!="PRODUITS MANUFACTURES" & SPECIFICITE!="PRODUITS LAITIERS" & SPECIFICITE!="SUCRES") |>
  mutate(MoisAn=as.yearmon(DATE, "%m/%Y"),
         TauxVar=round((PRIX-PRIXPREC)/PRIXPREC,2),
         ANNEE=as.character(ANNEE)
  ) |>
  group_by(VILLE) |>
  summarise(PrixMoy=round(mean(PRIX,na.rm = TRUE),4),
            VarMoy=round(mean(TauxVar,na.rm =TRUE),4),
            VarMoyAbs=round(mean(abs(TauxVar),na.rm =TRUE),4))
indicateurs_recap0 <- left_join(indicateurs_recap,adressRegion1, by=c("VILLE"="value"))

# Indicateur carte recherche


indicateurs <- priceGlobCleanFull |>
  filter(CATEGORIE!="PRODUITS MANUFACTURES" & SPECIFICITE!="PRODUITS LAITIERS" & SPECIFICITE!="SUCRES") |>
  mutate(MoisAn=as.yearmon(DATE, "%m/%Y"),
         TauxVar=round((PRIX-PRIXPREC)/PRIXPREC,2),
         ANNEE=as.character(ANNEE),
  ) |>
  group_by(VILLE,SPECIFICITE,PRODUITS) |>
  summarise(PrixMoy=round(mean(PRIX,na.rm = TRUE),4),
            VarMoy=round(mean(TauxVar,na.rm =TRUE),4),
            VarMoyAbs=round(mean(abs(TauxVar),na.rm =TRUE),4))

# Filtrer les données pour les villes où VarMoyAbs est la plus petite
indicateurs <- left_join(indicateurs,adressRegion1, by=c("VILLE"="value"))

##############################################################################
### Analyse par DATE
# Importation du jeu de données
DatasetPriceInit <- read_csv("data/priceGlobCleanFull.csv") |> 
  filter(CATEGORIE!="PRODUITS MANUFACTURES")

# Pour les formating
up_arrow <- "<span style=\"color:red\">&#9650;</span>"
down_arrow <- "<span style=\"color:green\">&#9660;</span>"

# Processing
DatasetPrice <- DatasetPriceInit |>
  group_by(PRODUITS,VILLE) |>
  mutate(PRIXPREC=lag(PRIX,order_by = DATE)) |> 
  mutate(MoisAn=as.yearmon(DATE, "%m/%Y"),
         MOIS=month(DATE,label=TRUE),
         TauxVar=round((PRIX-PRIXPREC)/PRIXPREC,2)) |> 
  filter(CATEGORIE!="PRODUITS MANUFACTURES")


# Chargement des ressources du SIDEBAR
uniqueVille <- c("TOUT",unique(DatasetPriceInit$VILLE))
uniqueCateg <- c("TOUT",unique(DatasetPriceInit$CATEGORIE))
uniqueProd <- c("TOUT",unique(DatasetPriceInit$PRODUITS))
uniqueSousCat <- c("TOUT",unique(DatasetPriceInit$`SOUS-CATEGORIE`))
uniqueSpecifite <- c("TOUT",unique(DatasetPriceInit$SPECIFICITE))
uniqueAnnee <- c("TOUT",unique(DatasetPriceInit$ANNEE ))


# Fonction permettant l'annotation du graph

addShadNot <- function(dygraph,tabl){
  
  # Initialisation des variables
  
  ## Variable des dates de début et fin
  dateDebutInit <- tabl |> pluck(1,1)
  dateFinInit <- tabl |> pluck(2,1)
  dateMil <- tabl |> pluck(6,1)
  dateQuarter <- tabl |> pluck(4,1)
  
  ## Variable des texts
  textAbrev <- tabl |> pluck(7,1) |> substr(1,5) # Texts abrégés
  textFull <- tabl |> pluck(7,1)
  
  # Ajout des annotations
  obj <- dygraph |> dyShading(from =dateDebutInit, to = dateFinInit,color = "#F5F1FD")
  obj <- obj |> dyAnnotation(dateMil,
                             text = textAbrev,
                             tooltip = str_c("les ",
                                             textFull,
                                             " sont plus accessibles \n au ",
                                             dateQuarter),
                             attachAtBottom = TRUE,
                             width = 40)
  
  for (i in 2:dim(tabl)[1]){
    
    # Ensemble de couleur
    color = c("#FFE6E6","#F5F1FD")
    # choix de la couleur
    color =color[c(i%%2==0,i%%2==1)]
    
    # Récupération des dates de débuts et de fin
    dateDebutInit <- tabl |> pluck(1,i)
    dateFinInit <- tabl |> pluck(2,i)
    dateMil <- tabl |> pluck(6,i)
    dateQuarter <- tabl |> pluck(4,i)
    
    textAbrev <- tabl |> pluck(7,i) |> substr(1,5)
    textFull <- tabl |> pluck(7,i)
    
    # Ajout du shading
    obj <- obj |> dyShading(from = dateDebutInit, to = dateFinInit,color = color)
    
    # Ajout des annotations
    obj <- obj |> dyAnnotation(dateMil,
                               text = textAbrev,
                               tooltip = str_c("les ",
                                               textFull,
                                               "S sont plus accessibles \n au ",
                                               dateQuarter),
                               attachAtBottom = TRUE,
                               width = 40)
  }
  return(obj)
}


# Fonction pour trouver la date la plus proche dans vecB pour une date donnée
find_closest_date <- function(date, vec) {
  closest_date <- vec[which.min(abs(vec - date))]
  return(closest_date)
}

# Table des dates comportant les semestres
SemestreTable <- tibble(
  debut=c("2020-1-1","2020-4-1","2020-7-1","2020-10-1",
          "2021-1-1","2021-4-1","2021-7-1","2021-10-1",
          "2022-1-1","2022-4-1","2022-7-1","2022-10-1"
  ),
  fin=c("2020-3-31","2020-6-30","2020-9-30","2020-12-31",
        "2021-3-31","2021-6-30","2021-9-30","2021-12-31",
        "2022-3-31","2022-6-30","2022-9-30","2022-12-31"
  )
)



# Ajout des semestres à la table (pas besoin de chargement ultérieur)
SemestreTable <- SemestreTable |>
  mutate(Date=as.Date(fin)) |>
  mutate(Quarter=as.yearqtr(Date),
         DateMil=Date %m-% months(1),
         DateMilFind= sapply(DateMil,
                             function(date) find_closest_date(date, DatasetPrice$DATE))|>
           as.Date()
  )

# Fonction permettant d'avoir le min et le max sur le graph
addMinMax <- function(dygraph,tbl){
  
  dateMin <- tbl |> pluck(1,1) |> as.character()
  dateMax <- tbl |> pluck(1,2) |> as.character()
  obj <- dygraph |>
    dyAnnotation(dateMin, text = "Min", tooltip = "Prix moyen minimum",width = 30) |>
    dyAnnotation(dateMax, text = "Max", tooltip = "Prix moyen maximum",width = 30)
  
  # if(colnames(tbl)[2]=="VarMoy"){
  #   dateMin <- tbl |> pluck(1,1) |> as.character()
  #   dateMax <- tbl |> pluck(1,2) |> as.character()
  #   obj <- dygraph |> 
  #     dyAnnotation(dateMin, text = "Min", tooltip = "Prix moyen minimum",width = 30) |> 
  #     dyAnnotation(dateMax, text = "Max", tooltip = "Prix moyen maximum",width = 30)
  # }else{
  #   dateMin <- tbl |> pluck(1,1) |> as.character()
  #   dateMax <- tbl |> pluck(1,2) |> as.character()
  #   obj <- dygraph |> 
  #     dyAnnotation(dateMin, text = "Min", tooltip = "Prix moyen minimum",width = 30) |> 
  #     dyAnnotation(dateMax, text = "Max", tooltip = "Prix moyen maximum",width = 30)
  # }
  
  return(obj)
}

# Fonction premettant de renommer les indicateurs
renameIndicator <- function(ind){
  ind <- switch(ind,
                "Prix Moyen" = "PrixMoy",
                "Taux de variat. moy." = "VarMoy",
                "Taux de variat. moy. (absolu)" = "VarMoyAbs",
                ind)
  return(ind)
}

# Fonction premettant de renommer les indicateurs depuis leur nom abrégé
renameIndicatorInv <- function(indInv){
  indInv <- switch(indInv,
                "PrixMoy"="Prix Moyen",
                "VarMoy"="Taux de variat. moy.",
                "VarMoyAbs"="Taux de variat. moy. (absolu)",
                indInv)
  return(indInv)
}

# Fonction pour le formatages des indicateurs
formatingtable <- function(ind,prev,act){
  ind <- switch(ind,
                "Prix Moyen" = prev<act,
                "Taux de variat. moy." = prev<act,
                "Taux de variat. moy. (absolu)" = prev<act,
                ind)
  return(ind)
}

# Fonction pour l'ajout de filtre
filterOption <- function(tidyExp,sideFilter,Var){
  if(sideFilter=="TOUT"){
    return(tidyExp)
  }else{
    return(tidyExp |> filter(!!sym(Var)==sideFilter))
  }
}




################################################################################