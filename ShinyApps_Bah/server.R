#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#



# Define server logic required to draw a histogram
function(input, output, session) {
    
  ##########################################################""
  # Analyse par region
  # Sidebar action
      # Met à jour les choix des produits en fonction de la catégorie sélectionnée
      observeEvent(input$categorie, {
        # Filtrer les produits en fonction de la catégorie sélectionnée
        filtered_products <- priceGlob[priceGlob$SPECIFICITE == input$categorie, "PRODUITS"]
        
        # Mettre à jour les choix du selectizeInput des produits
        updateSelectizeInput(session, "produit", choices = unique(filtered_products), selected = unique(filtered_products)[1])
      })
  
  
  # Carte1
  
  output$aRegionM <- renderLeaflet({
    #Selection de l'indicateur choisi
    selected_indicateur <- input$indicateur
    
    # Joindre les données
    dpt1 <- left_join(dpt2, indicateurs_recap, by = c("VilleProche" = "VILLE"))
    
    # Créer une palette de couleurs pour l'indicateur sélectionné
    pal <- colorNumeric(
      palette = "YlOrRd",
      domain = indicateurs_recap0[[selected_indicateur]],
      na.color = "transparent"
    )
    
    # Créer la carte leaflet
    leaflet(dpt1) |>
      addProviderTiles("OpenStreetMap") |>
      addPolygons(
        fillColor = ~pal(get(selected_indicateur)),
        weight = 2,
        opacity = 1,
        color = "white",
        dashArray = "3",
        fillOpacity = 0.7,
        highlight = highlightOptions(
          weight = 5,
          color = "#666",
          dashArray = "",
          fillOpacity = 0.7,
          bringToFront = TRUE
        ),
        label = ~paste0(get(selected_indicateur)),
        labelOptions = labelOptions(
          style = list("font-weight" = "normal", padding = "3px 8px"),
          textsize = "15px",
          direction = "auto"
        )
      ) %>%
      addMarkers(
        data = indicateurs_recap0,
        lng = ~long,
        lat = ~lat,
        popup = ~paste0("<strong>", VILLE, "</strong><br>", selected_indicateur, ": ", get(selected_indicateur))
      ) %>%
      addLegend(
        pal = pal,
        values = indicateurs_recap0[[selected_indicateur]],
        opacity = 0.7,
        title = selected_indicateur,
        position = "bottomright"
      )
  })
  

    
  
  ###############################""
  # Boxplot
  # Rendre le boxplot basé sur le produit et la ville sélectionnés
  output$aRegionP <- renderPlotly({
    # Filtrer les données priceGlob en fonction du produit et de la date sélectionnés
    
    filtered_data <- priceGlob|>filter(PRODUITS == input$produit & ANNEE == input$date)|>select(c(VILLE,PRODUITS,ANNEE,PRIX))
    
    # Créer un graphique de boîte à moustaches avec 
    p <- ggplot(filtered_data, aes(x = VILLE, y = PRIX, fill = VILLE)) +
      geom_boxplot() +
      labs(title = paste("Boîte à moustaches des prix pour", input$produit, "en", input$date),
           x = "Ville", y = "Prix")+
      scale_fill_brewer(palette = "Set3")
    # Convertir le graphique ggplot en un graphique interactif Plotly
    ggplotly(p)
  })

  ###############################"
  #Tableau indicateur
  output$table <- renderDT({
    indicateurs_recap
  })
  
#####################################""
  #recherche
  
  #Selection de l'indicateur choisi
  indicateur <- reactive({
    input$indicateur
  })
  
  villes_min_indicateur <- reactive({
    selected_indicateur <- indicateur()
    
    indicateurs %>%
      group_by(VILLE, SPECIFICITE) %>%
      mutate(rank = min_rank(get(selected_indicateur))) %>%
      filter(rank == 1) %>%
      distinct(PRODUITS, .keep_all = TRUE)
  })
  
  output$aRegionMr <- renderLeaflet({
    selected_indicateur <- indicateur()
    ##### 
    villes_min_indicateur <- villes_min_indicateur()
    
    # Agréger les spécificités par ville
    villes_agg <- villes_min_indicateur %>%
      group_by(VILLE) %>%
      slice_min(get(selected_indicateur), with_ties = FALSE) %>%
      ungroup()
    #####
    
    # Définir une palette de couleurs
    palette_couleurs <- rainbow(length(unique(villes_agg$VILLE)))
    
    
      # Créer une carte Leaflet
    leaflet() |>
      addProviderTiles("OpenStreetMap.Mapnik") |>
      addPolygons(data = dpt2,
                  stroke = FALSE,
                  color = palette_couleurs[match(dpt2$VilleProche, villes_agg$VILLE)])|>
      addMarkers(data = villes_agg,
                 lng = ~long,
                 lat = ~lat,
                 popup = ~paste(VILLE, "<br>SPECIFICITE: ", SPECIFICITE),
      )|>
      addLegend(position = "bottomright", 
                colors = palette_couleurs, 
                labels = unique(villes_agg$VILLE),
                title = "Villes")
    
  })
  
  
  output$table2 <- renderDT({
    #Selection de l'indicateur choisi
    selected_indicateur <- indicateur()
    villes_min_indicateur <- villes_min_indicateur()
    villes_min_indicateur|>select(VILLE,SPECIFICITE,!!selected_indicateur)
  })
  
  
}
