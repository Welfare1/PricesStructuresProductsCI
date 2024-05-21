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

dpt <- read_sf("data/civ")
priceGlob <- read.csv("data/priceGlobCleanFully.csv")
VillePaysVilleProche1 <- read_csv("data/VillePaysVilleProche.csv", show_col_types = FALSE)
adressRegion1 <- read_csv("data/adressRegion.csv", show_col_types = FALSE)

# Jointure avec la base de données sf des villes de la côte d'ivoire
dpt2 <- left_join(dpt,VillePaysVilleProche1,join_by(ADM3_FR==VillePays))

###############################
#Indicateur

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
indicateurs_recap0 <- left_join(indicateurs_recap,adressRegion1, by=c("VILLE"="value"))

# Indicateur carte recherche


indicateurs <- priceGlobCleanFull |>
  filter(CATEGORIE!="PRODUITS MANUFACTURES" & SPECIFICITE!="PRODUITS LAITIERS" & SPECIFICITE!="SUCRES") |>
  mutate(MoisAn=as.yearmon(DATE, "%m/%Y"),
         TauxVar=round((PRIX-PRIXPREC)/PRIXPREC,2),
         ANNEE=as.character(ANNEE),
  ) |>
  group_by(VILLE,SPECIFICITE,PRODUITS) |>
  summarise(PrixMoy=mean(PRIX,na.rm = TRUE),
            VarMoy=mean(TauxVar,na.rm =TRUE),
            VarMoyAbs=mean(abs(TauxVar),na.rm =TRUE))

# Filtrer les données pour les villes où VarMoyAbs est la plus petite
indicateurs <- left_join(indicateurs,adressRegion1, by=c("VILLE"="value"))




