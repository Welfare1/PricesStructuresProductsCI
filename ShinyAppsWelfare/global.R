library(shiny)
library(tidyverse)
library(zoo)
library(plotly)
library(bslib)
library(dygraphs)
# Importation du jeu de données
DatasetPrice <- read_csv("data/priceGlobCleanFull.csv")

DatasetPrice <-DatasetPrice |>  mutate(MoisAn=as.yearmon(DATE, "%m/%Y"),
       TauxVar=round((PRIX-PRIXPREC)/PRIXPREC,2)) |> 
  filter(CATEGORIE!="PRODUITS MANUFACTURES")