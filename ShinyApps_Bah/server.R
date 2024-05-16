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
  # Carte
  
  output$aRegionM <- renderLeaflet({
    leaflet() %>%
      addProviderTiles("OpenStreetMap.Mapnik") %>%
      addPolygons(data = dpt2, fillColor = "blue", fillOpacity = 0.2)
  })
    
  
  ###############################""
  # Boxplot
  
  # Filtrer les données priceGlob en fonction du produit et de la date sélectionnés
  filteredPriceGlob <- reactive({
    subset(priceGlob, PRODUITS == input$produit & DATE == input$date)
  })
  
  # Rendre le boxplot basé sur le produit et la ville sélectionnés
  output$aRegionP <- renderPlot({
   
    filtered_data <- filteredPriceGlob()
    
    ggplot(filtered_data, aes(x = VILLE, y = PRIX)) +
      geom_boxplot() +
      labs(title = paste("Boîte à moustaches des prix pour", input$produit, "le", input$date),
           x = "Ville", y = "Prix")
  })

    

}
