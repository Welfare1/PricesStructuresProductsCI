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