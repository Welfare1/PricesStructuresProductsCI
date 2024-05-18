library(shiny)
library(tidyverse)
library(zoo)
library(plotly)
library(bslib)
library(dygraphs)
library(gt)

##############################################################################

# Importation du jeu de données
DatasetPrice <- read_csv("data/priceGlobCleanFull.csv")

# Processing
DatasetPrice <- DatasetPrice |>
  group_by(PRODUITS,VILLE) |>
  mutate(PRIXPREC=lag(PRIX,order_by = DATE))

DatasetPrice <-DatasetPrice |>  mutate(MoisAn=as.yearmon(DATE, "%m/%Y"),
       TauxVar=round((PRIX-PRIXPREC)/PRIXPREC,2)) |> 
  filter(CATEGORIE!="PRODUITS MANUFACTURES")

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



## Ajout des semestres à la table
SemestreTable <- SemestreTable |> 
  mutate(Date=as.Date(fin)) |>
  mutate(Quarter=as.yearqtr(Date),
         DateMil=Date %m-% months(1),
         DateMilFind= sapply(DateMil,
                             function(date) find_closest_date(date, priceGlobCleanFull$DATE))|>
           as.Date()
         )




################################################################################
