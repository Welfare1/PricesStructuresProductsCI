

# Define server logic required to draw a histogram
function(input, output, session) {
  
  output$distPlot <- renderPlot({
    
    # generate bins based on input$bins from ui.R
    x    <- faithful[, 2]
    bins <- seq(min(x), max(x), length.out = input$bins + 1)
    
    # draw the histogram with the specified number of bins
    hist(x, breaks = bins, col = 'darkgray', border = 'white',
         xlab = 'Waiting time to next eruption (in mins)',
         main = 'Histogram of waiting times')
    
  })
  
  DatasetPriceSeries <- reactive({
    DatasetPriceSeries <- DatasetPrice|>
      group_by(DATE) |>
      summarise(PrixMoy=mean(PRIX,na.rm = TRUE),
                VarMoy=mean(TauxVar,na.rm =TRUE),
                VarMoyAbs=mean(abs(TauxVar),na.rm =TRUE)) |>
      select(DATE,PrixMoy)
  })
  
  DatasetPriceMois <- reactive({
    DatasetPriceMois <- DatasetPrice|>
      ungroup()|>
      pivot_wider(id_cols = MOISNum,
                  names_from = ANNEE,
                  values_from = PRIX,
                  values_fn = ~ mean(.x, na.rm = TRUE)) 
  })
  
  
  output$wel_dygraph <- renderDygraph({
    dygraph(DatasetPriceSeries(),
            main = "Evolution du prix moyen") |> 
      dyRangeSelector() |> 
      dyOptions(stackedGraph = TRUE)
  })
  
  output$wel_dygraphMois <- renderDygraph({
    dygraph(DatasetPriceMois(),
            main = "Evolution du prix moyen par année") |> 
      dyOptions(fillGraph = TRUE, fillAlpha = 0.4,colors = RColorBrewer::brewer.pal(1, "Dark2"))
  })
  
  output$wel_dygraphSai <- renderDygraph({
    dygraph(DatasetPriceSeries(),
            main = "Evolution du prix moyen") |> 
      dyOptions(stackedGraph = TRUE)
  })
  
  
  
}
