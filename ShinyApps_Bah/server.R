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
  # Carte
  
  output$aRegionM <- renderLeaflet({
    leaflet() %>%
      addProviderTiles("OpenStreetMap.Mapnik") %>%
      addPolygons(data = dpt2, fillColor = "blue", fillOpacity = 0.2)
  })
    
  
  ###############################""
  # Boxplot
  # Rendre le boxplot basé sur le produit et la ville sélectionnés
  output$aRegionP <- renderPlot({
    # Filtrer les données priceGlob en fonction du produit et de la date sélectionnés
    
    filtered_data <- priceGlob|>filter(PRODUITS == input$produit & ANNEE == input$date)|>select(c(VILLE,PRODUITS,ANNEE,PRIX))
    
    ggplot(filtered_data, aes(x = VILLE, y = PRIX)) +
      geom_boxplot() +
      labs(title = paste("Boîte à moustaches des prix pour", input$produit, "en", input$date),
           x = "Ville", y = "Prix")
  })

  ###############################"
  #Tableau indicateur
  output$table <- renderTable({
    indicateurs_recap
  })

}
