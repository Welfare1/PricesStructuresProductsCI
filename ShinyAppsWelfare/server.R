

# Define server logic required to draw a histogram
function(input, output, session) {
  
  
  #################################################################################
  # SIDEBAR
  ## Met à jour les choix des sous-catégories en fonction de la catégorie sélectionnée
  observeEvent(input$wel_categorie, {
    ### Filtrer les produits en fonction de la catégorie sélectionnée
    if(input$wel_categorie=="TOUT"){
      filtered_products <- DatasetPriceInit |>
        select(`SOUS-CATEGORIE`)
    }else{
      filtered_products <- DatasetPriceInit |> 
        filter(CATEGORIE==input$wel_categorie) |>
        select(`SOUS-CATEGORIE`)
    }
    
    ### Mettre à jour les choix du selectizeInput des produits
    ### Vecteur unique des produits filtrés
    UnivectProd <- c("TOUT",unique(filtered_products))
    updateSelectizeInput(session,
                         "wel_SousCat",
                         selected = UnivectProd[1],
                         choices = UnivectProd
                         )
  })

  ## Met à jour les choix des sous-catégories en fonction de la catégorie sélectionnée
  observeEvent(input$wel_SousCat, {
    ### Filtrer les produits en fonction de la catégorie sélectionnée
    if(input$wel_SousCat=="TOUT"){
      filtered_products <- DatasetPriceInit |>
        select(SPECIFICITE)
    }else{
      filtered_products <- DatasetPriceInit |>
        filter(`SOUS-CATEGORIE`==input$wel_SousCat) |>
        select(SPECIFICITE)
    }

    ### Mettre à jour les choix du selectizeInput des produits
    ### Vecteur unique des produits filtrés
    UnivectProd <- c("TOUT",unique(filtered_products))
    updateSelectizeInput(session,
                         "wel_Specificite",
                         selected = UnivectProd[1],
                         choices = UnivectProd
    )
  })
  
  ## Met à jour les choix des sous-catégories en fonction de la catégorie sélectionnée
  observeEvent(input$wel_Specificite, {
    ### Filtrer les produits en fonction de la catégorie sélectionnée
    if(input$wel_Specificite=="TOUT"){
      filtered_products <- DatasetPriceInit |>
        select(PRODUITS)
    }else{
      filtered_products <- DatasetPriceInit |>
        filter(SPECIFICITE==input$wel_Specificite) |>
        select(PRODUITS)
    }
    
    ### Mettre à jour les choix du selectizeInput des produits
    ### Vecteur unique des produits filtrés
    UnivectProd <- c("TOUT",unique(filtered_products))
    updateSelectizeInput(session,
                         "wel_produit",
                         selected = UnivectProd[1],
                         choices = UnivectProd
    )
  })
  
  # Dataset première times series
  
  DatasetPriceSeries <- reactive({
    DatasetPriceSeries <- DatasetPrice|>
      filterOption(input$wel_ville,"VILLE") |> 
      filterOption(input$wel_date,"ANNEE") |>
      filterOption(input$wel_categorie,"CATEGORIE") |>
      filterOption(input$wel_SousCat,"SOUS-CATEGORIE") |>
      filterOption(input$wel_Specificite,"SPECIFICITE") |>
      filterOption(input$wel_produit,"PRODUITS") |>
      group_by(DATE) |>
      summarise(PrixMoy=mean(PRIX,na.rm = TRUE),
                VarMoy=mean(TauxVar,na.rm =TRUE),
                VarMoyAbs=mean(abs(TauxVar),na.rm =TRUE)) |>
      select(DATE,!!sym(renameIndicator(input$wel_indicateur)))
  })
  
  # Dataset contenant les valeurs min et max selon les indicateurs
  
  RankTableMinMax <- reactive({
    RankTableMinMax <- DatasetPrice |>
      filterOption(input$wel_ville,"VILLE") |>
      filterOption(input$wel_date,"ANNEE") |>
      filterOption(input$wel_categorie,"CATEGORIE") |>
      filterOption(input$wel_SousCat,"SOUS-CATEGORIE") |>
      filterOption(input$wel_Specificite,"SPECIFICITE") |>
      group_by(DATE) |>
      summarise(PrixMoy=mean(PRIX,na.rm = TRUE),
                VarMoy=mean(TauxVar,na.rm =TRUE),
                VarMoyAbs=mean(abs(TauxVar),na.rm =TRUE)) |>
      select(DATE,!!sym(renameIndicator(input$wel_indicateur))) |> 
      mutate(RankMin=min_rank(!!sym(renameIndicator(input$wel_indicateur))),
             RankMax=min_rank(-!!sym(renameIndicator(input$wel_indicateur)))) |> 
      filter(RankMin==1 | RankMax==1) |> 
      arrange(-desc(RankMin)) |> 
      distinct(RankMin,.keep_all = TRUE) |> 
      distinct(RankMax,.keep_all = TRUE)
  })
  
  # Dataset Times series cycliques
  
  DatasetPriceMois <- reactive({
    DatasetPriceMois <- DatasetPrice|>
      filterOption(input$wel_ville,"VILLE") |>
      filterOption(input$wel_categorie,"CATEGORIE") |>
      filterOption(input$wel_SousCat,"SOUS-CATEGORIE") |>
      filterOption(input$wel_Specificite,"SPECIFICITE") |>
      group_by(ANNEE,MOISNum) |> 
      summarise(PrixMoy=mean(PRIX,na.rm = TRUE),
                VarMoy=mean(TauxVar,na.rm =TRUE),
                VarMoyAbs=mean(abs(TauxVar),na.rm =TRUE)) |> 
      pivot_wider(id_cols = MOISNum,
                  names_from = ANNEE,
                  values_from = !!sym(renameIndicator(input$wel_indicateur))
                  )
  })
  
  # Tables des indicateurs
  DatasetSummInd <- reactive({
    DatasetSummInd <- DatasetPrice|>
      filterOption(input$wel_ville,"VILLE") |>
      filterOption(input$wel_categorie,"CATEGORIE") |>
      filterOption(input$wel_SousCat,"SOUS-CATEGORIE") |>
      filterOption(input$wel_Specificite,"SPECIFICITE") |>
      filter(CATEGORIE!="PRODUITS MANUFACTURES") |>
      group_by(ANNEE,MOIS) |>
      summarise(PrixMoy=mean(PRIX,na.rm = TRUE),
                VarMoy=mean(TauxVar,na.rm =TRUE),
                VarMoyAbs=mean(abs(TauxVar),na.rm =TRUE)) |>
      pivot_wider(names_from =ANNEE,
                  values_from = !!sym(renameIndicator(input$wel_indicateur)),
                  id_cols = MOIS )
  })
  
  
  # Dataset contenant les meilleurs produits par saison
  ## récupération du classement des produits
  
  DatasetPriceRank <- reactive({
    indicateur1 <- DatasetPrice |>
      filterOption(input$wel_ville,"VILLE") |>
      filterOption(input$wel_date,"ANNEE") |>
      filterOption(input$wel_categorie,"CATEGORIE") |>
      filterOption(input$wel_SousCat,"SOUS-CATEGORIE") |>
      filterOption(input$wel_Specificite,"SPECIFICITE") |>
      filter(CATEGORIE!="PRODUITS MANUFACTURES") |>
      mutate(MoisAn=as.yearmon(DATE),
             QuarterAn=as.yearqtr(DATE),
             TauxVar=round((PRIX-PRIXPREC)/PRIXPREC,2),
      ) |>
      group_by(ANNEE,QuarterAn,`SOUS-CATEGORIE`) |> 
      summarise(PrixMoy=mean(PRIX,na.rm = TRUE),
                VarMoy=mean(TauxVar,na.rm =TRUE),
                VarMoyAbs=mean(abs(TauxVar),na.rm =TRUE)) |> 
      mutate(Rank=min_rank(!!sym(renameIndicator(input$wel_indicateur)))) |>
      filter(Rank==1)|> 
      ungroup() |>
      distinct(QuarterAn,.keep_all=TRUE)
  
  })
  
  # Table contenant les noms des produits et leur catégorie

  ranKTable <- reactive({
    ranKTable <- left_join(SemestreTable,
                           DatasetPriceRank() |> 
                             select(QuarterAn,`SOUS-CATEGORIE`),
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
    RankTableSai <-  DatasetPrice |>
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
  
  # Times series principales
  output$wel_dygraph <- renderDygraph({
    dygraph(DatasetPriceSeries(),
            main = str_c(input$wel_indicateur," sur les différentes années")) |> 
      dyRangeSelector() |> 
      dyOptions(stackedGraph = TRUE) |> 
      addMinMax(RankTableMinMax())
  })
  
  # Times series secondaires
  output$wel_dygraphMois <- renderDygraph({
    dygraph(DatasetPriceMois(),
            main = str_c(input$wel_indicateur," par année")) |> 
      dyOptions(fillGraph = TRUE,
                fillAlpha = 0.4,
                colors = RColorBrewer::brewer.pal(1, "Dark2"))
  })
  
  output$wel_dygraphSai <- renderDygraph({
    DatasetPriceSeries() |>
    dygraph(main = "Produit par saison") |>
      dyOptions(fillGraph = TRUE,
                fillAlpha = 0.1,
                colors = RColorBrewer::brewer.pal(1, "Dark2")) |>
      addShadNot(ranKTable())
  })
  
  output$wel_tableSaiRecap1 <-  render_gt(
    expr = DatasetSummInd() |> 
      gt() |> 
      opt_interactive(
        use_filters = FALSE,
        use_search = FALSE,
        use_compact_mode = TRUE,
        use_text_wrapping = FALSE
      ) |> 
      fmt_number(columns = c(`2020`,`2021`,`2022`)) |>
      # Formatage
      # 2020
      text_transform(
        locations = cells_body(
          columns = `2020`,
          rows = formatingtable(input$wel_indicateur,`2020`,`2021`)
        ),
        fn = function(x) paste(x,down_arrow)
      ) |>
      text_transform(
        locations = cells_body(
          columns = `2020`,
          rows = !formatingtable(input$wel_indicateur,`2020`,`2021`)
        ),
        fn = function(x) paste(x,up_arrow)
      ) |> 
      # 2021
      text_transform(
        locations = cells_body(
          columns = `2021`,
          rows = formatingtable(input$wel_indicateur,`2021`,`2022`)
        ),
        fn = function(x) paste(x,down_arrow)
      ) |>
      text_transform(
        locations = cells_body(
          columns = `2021`,
          rows = !formatingtable(input$wel_indicateur,`2021`,`2022`)
        ),
        fn = function(x) paste(x,up_arrow)
      )
  )
  
  
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
