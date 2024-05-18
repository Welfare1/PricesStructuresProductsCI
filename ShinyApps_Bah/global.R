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

dpt <- read_sf("data/civ")
priceGlob <- read.csv("data/priceGlobCleanFull.csv")

# Géolocalisation des villes de bases
region <- unique(priceGlob$VILLE) |> as_tibble()
region$value[2] <- "SAN-PEDRO"
region <- region |> mutate(pays = "Cote d'Ivoire")
adressRegion <- geocode(region,city = value, country = pays)

# Ajout de l'attribut geometry
adressRegionGeo <- adressRegion |> st_as_sf(coords = c("long","lat")) |> st_set_crs(4326)

# Les centroïdes des villes de bases
centroVilleBase <- st_centroid(adressRegionGeo$geometry)

# centroïdes des villes de la côte d'ivoire
centroVilleEntiere <- st_centroid(dpt$geometry)

# Estimation des distances entre les villes de la côte d'ivoire et les villes de base
MatriceDistance <- st_distance(centroVilleEntiere,centroVilleBase,which = "Great Circle")

# Ville du pays et la ville de base la plus proche
VillePaysVilleProche <- MatriceDistance  |>
  apply(1,order)|> 
  t() |> 
  as_tibble()|>
  select(V1) |> 
  mutate(VillePays=dpt$ADM3_FR,VilleProche=map_chr(V1,~region$value[.x])) |> select(2:3)

# Jointure avec la base de données sf des villes de la côte d'ivoire
dpt2 <- left_join(dpt,VillePaysVilleProche,join_by(ADM3_FR==VillePays))

###############################"""
#Indicateur
adressRegion$value[2] <- "SANPEDRO"
priceGlobCleanFull <- priceGlob |>
  group_by(PRODUITS,VILLE) |>
  mutate(PRIXPREC=lag(PRIX,order_by = DATE)) # Dataset de base

# Indicateur_recap
indicateurs_recap <- priceGlobCleanFull |>
  filter(CATEGORIE!="PRODUITS MANUFACTURES" & SPECIFICITE!="PRODUITS LAITIERS" & SPECIFICITE!="SUCRES") |>
  mutate(MoisAn=as.yearmon(DATE, "%m/%Y"),
         TauxVar=round((PRIX-PRIXPREC)/PRIXPREC,2),
         ANNEE=as.character(ANNEE)
  ) |>
  group_by(VILLE) |>
  summarise(PrixMoy=mean(PRIX,na.rm = TRUE),
            VarMoy=mean(TauxVar,na.rm =TRUE),
            VarMoyAbs=mean(abs(TauxVar),na.rm =TRUE))
indicateurs_recap0 <- left_join(indicateurs_recap,adressRegion, by=c("VILLE"="value"))

# Indicateur carte recherche


indicateurs <- priceGlobCleanFull |>
  filter(CATEGORIE!="PRODUITS MANUFACTURES" & SPECIFICITE!="PRODUITS LAITIERS" & SPECIFICITE!="SUCRES") |>
  mutate(MoisAn=as.yearmon(DATE, "%m/%Y"),
         TauxVar=round((PRIX-PRIXPREC)/PRIXPREC,2),
         ANNEE=as.character(ANNEE),
  ) |>
  group_by(VILLE,CATEGORIE,SPECIFICITE,PRODUITS) |>
  summarise(PrixMoy=mean(PRIX,na.rm = TRUE),
            VarMoy=mean(TauxVar,na.rm =TRUE),
            VarMoyAbs=mean(abs(TauxVar),na.rm =TRUE))

# Filtrer les données pour les villes où VarMoyAbs est la plus petite
indicateurs <- left_join(indicateurs,adressRegion, by=c("VILLE"="value"))

villes_min_VarMoy <- indicateurs%>%
  group_by(VILLE) %>%
  mutate(rank=min_rank(VarMoy))|>
  filter(rank==1)|>
  distinct(PRODUITS,.keep_all=TRUE)

# Agréger les spécificités par ville
villes_agg <- villes_min_VarMoy %>%
  group_by(VILLE,SPECIFICITE,PRODUITS, lat, long) %>%
  summarise()

# Définir une palette de couleurs
palette_couleurs <- rainbow(length(unique(villes_agg$VILLE)))


