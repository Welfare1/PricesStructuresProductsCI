

# Define server logic required to draw a histogram
function(input, output, session) {
  
  
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
  
  # Dataset contenant les meilleurs produits par saison
  ## récupération du classement des produits
  
  DatasetPriceRank <- reactive({
    indicateur1 <- DatasetPrice |>
      # filter(ANNEE==2020) |>
      filter(CATEGORIE!="PRODUITS MANUFACTURES") |>
      mutate(MoisAn=as.yearmon(DATE),
             QuarterAn=as.yearqtr(DATE),
             TauxVar=round((PRIX-PRIXPREC)/PRIXPREC,2),
      ) |>
      group_by(ANNEE,QuarterAn,`SOUS-CATEGORIE`) |> 
      summarise(PrixMoy=mean(PRIX,na.rm = TRUE),
                VarMoy=mean(TauxVar,na.rm =TRUE),
                VarMoyAbs=mean(abs(TauxVar),na.rm =TRUE)) |> 
      mutate(Rank=min_rank(VarMoy)) |>
      filter(Rank==1)|> 
      ungroup() |>
      distinct(QuarterAn,.keep_all=TRUE)
  
  })
  
  # Table contenant les noms des produits et leur catégorie
  
  ranKTable <- reactive({
    ranKTable <- left_join(SemestreTable,
                           DatasetPriceRank() |> select(QuarterAn,`SOUS-CATEGORIE`),
                           join_by(Quarter==QuarterAn),
                           keep = FALSE)
  })
  
  # Table des saisonnalités cycliques
  DatasetPriceSai <- reactive({
    indicateur2 <- DatasetPrice |>
      filter(CATEGORIE!="PRODUITS MANUFACTURES") |>
      mutate(MoisAn=as.yearmon(DATE),
             QuarterAn=as.yearqtr(DATE),
             TauxVar=round((PRIX-PRIXPREC)/PRIXPREC,2)) |> 
      group_by(ANNEE,MOIS)|> 
      summarise(PrixMoy=mean(PRIX,na.rm = TRUE),
                VarMoy=mean(TauxVar,na.rm =TRUE),
                VarMoyAbs=mean(abs(TauxVar),na.rm =TRUE)
                ) |> 
      ungroup() |> 
      pivot_wider(names_from = MOIS,values_from = PrixMoy,id_cols = ANNEE)
    
  })
  
  # Table recap page 3
  RankTableSai <- reactive({
    RankTableSai <- priceGlobCleanFull |>
      filter(CATEGORIE!="PRODUITS MANUFACTURES") |>
      ungroup() |> 
      mutate(MoisAn=as.yearmon(DATE),
             QuarterAn=as.yearqtr(DATE),
             TauxVar=round((PRIX-PRIXPREC)/PRIXPREC,2),
             QuarterName=str_c("Semestre ",quarter(DATE))
      ) |> 
      group_by(ANNEE,QuarterName,MOIS,SPECIFICITE) |> 
      summarise(PrixMoy=mean(PRIX,na.rm = TRUE),
                VarMoy=mean(TauxVar,na.rm =TRUE),
                VarMoyAbs=mean(abs(TauxVar),na.rm =TRUE)
      ) |> 
      mutate(Rank=min_rank(VarMoy)) |>
      filter(Rank==1)|> 
      ungroup() |> 
      distinct(ANNEE,QuarterName,MOIS,.keep_all = TRUE) |> 
      pivot_wider(names_from = ANNEE,
                  values_from = SPECIFICITE,
                  id_cols =c(QuarterName,MOIS)
      )
    
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
    DatasetPriceSeries() |> 
    dygraph(main = "Produit par saison") |> 
      dyOptions(fillGraph = TRUE,
                fillAlpha = 0.1,
                colors = RColorBrewer::brewer.pal(1, "Dark2")) |> 
      addShadNot(ranKTable())
  })
  
  
  output$wel_tableSai <-  render_gt(expr = DatasetPriceSai() |> 
                               gt() |>
                               fmt_number(decimals = 1) |>
                               cols_label_with(
                                 fn = ~ janitor::make_clean_names(., case = "title")
                               ) |>
                               data_color(
                                 columns = 2:13,
                                 direction="row",
                                 palette = "Reds"
                               ) |>
                              
                               tab_style(
                                 locations = cells_body(columns = ANNEE),
                                 style = cell_text(weight = "bold")
                               ) |>
                               opt_interactive(
                                 use_filters = FALSE,
                                 use_search = FALSE,
                                 use_compact_mode = TRUE,
                                 use_text_wrapping = FALSE
                               )
                             )
  output$wel_tableSaiRecap <-  render_gt(expr = RankTableSai() |> 
                                      gt(rowname_col = "MOIS", groupname_col = "QuarterName") |>
                                      cols_label(
                                        `2020` ~ md(">**2020**"),
                                        `2021` ~ md(">**2021**"),
                                        `2022` ~ md(">**2022**")
                                      ) |> 
                                      opt_stylize(style = 6, color = "pink")
                                      
  )
  
  
}
