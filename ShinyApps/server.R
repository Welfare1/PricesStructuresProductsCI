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
  # p("Trois indicateurs sont utilisés dans la mise en évidence des différentes variations
  #                               des prix selon les régions. L’intensité des couleurs sur les cartes est proportionnelle
  #                               à la valeur prise par l’indicateur. Les aproximations des prix sur toute l’étendue du 
  #                               térritoire se fait aux moyens de prévisions de prix selon leur proximité")
  
  # Mettre à jour le texte affiché
  output$texteAffiche <- renderText({
    "En première ligne on note les régions du Tonpki et le « Grand Abidjan » (réunion de la
     ville d’Abidjan, ainsi de villes adjacentes). Considéré comme épicentre de la propagation
    virale, « le grand Abidjan » est isolé du reste du territoire nationale à partir du 15 juillet.
    Le District Autonome d’Abidjan, capitale économique ivoirienne, détient la plus forte
    concentration d’habitants avec 2 994 Habitant/km2 (avec un total de 5 616 633 habitants,
    Abidjan est la ville la plus peuplée). Elle constitue ainsi une demande importante, qui 
    contribue à la hausse des prix au sein du district. Pour compte, Abidjan détient le prix
   moyen le plus élevés sur chaque sur la période de 2021. Avec des pics du prix moyen
   atteignant jusqu’à 1385 FCFA au 12/07/2021 contre 1045 FCFA sur l’année 2020 soit
   une croissance de 34%."
  })
  
  
  #Scrapping des prix recents du marché
  output$table_prix <- renderDT({
    # Lire le contenu HTML à partir de l'URL
    url_sika <- "https://www.sikafinance.com/conso/liste_des_prix"
    data_html <- read_html(url_sika)
    
    # Extraire et nettoyer les données du tableau
    prix_recent <- data_html |> 
      html_elements("td , th") |> 
      html_text2() |> 
      matrix(ncol = 9, byrow = TRUE) |> 
      as.data.frame()
    
    # Assigner la première ligne en tant que noms de colonnes
    colnames(prix_recent) <- prix_recent[1, ]
    prix_recent <- prix_recent[-1, ]
    
    # Nettoyer et convertir les colonnes 3 à 8 en numériques
    for (i in 3:8) {
      # Supprimer les espaces
      prix_recent[[i]] <- gsub("\\s+", "", prix_recent[[i]])
      # Supprimer tous les caractères non numériques (optionnel, dépend de vos données)
      prix_recent[[i]] <- gsub("[^0-9.]", "", prix_recent[[i]])
    }
    # Convertir les colonnes 3 à 8 en numériques, gérer les avertissements
    prix_recent <- prix_recent |> 
      mutate_at(vars(3:8), ~ as.double(.))
    # Trier les données par ordre alphabétique de la première colonne
    prix_recent <- prix_recent |> arrange(prix_recent[[1]])
    
    # Afficher le tableau trié
    
    datatable(prix_recent, options = list(
      initComplete = JS(
        "function(settings, json) {",
        "$(this.api().table().header()).css({'background-color': '#FE8700', 'color': '#fff'});",
        "}")
    ))
  })
  
  ##########################################################""
  # Analyse par region
  
  # Sidebar action
      # Met à jour les choix des produits en fonction de la catégorie sélectionnée
  observeEvent(input$Specificite, {
    ### Filtrer les produits en fonction de la catégorie sélectionnée
    if(input$Specificite=="TOUT"){
      filtered_products <- priceGlob |>
        select(PRODUITS)
    }else{
      filtered_products <- priceGlob |>
        filter(SPECIFICITE==input$Specificite) |>
        select(PRODUITS)
    }
    
    ### Mettre à jour les choix du selectizeInput des produits
    ### Vecteur unique des produits filtrés
    Prod <- c("TOUT",unique(filtered_products))
    updateSelectizeInput(session,
                         "produit",
                         selected = Prod[1],
                         choices = Prod
    )
  })
  
  
  # Carte1
  indicateurs_recap <- reactive({
    priceGlobCleanFull |>
      filterOption(input$date,"ANNEE")|>
      filter(CATEGORIE!="PRODUITS MANUFACTURES" & SPECIFICITE!="PRODUITS LAITIERS" & SPECIFICITE!="SUCRES") |>
      mutate(MoisAn=as.yearmon(DATE, "%m/%Y"),
             TauxVar=round((PRIX-PRIXPREC)/PRIXPREC,2),
             ANNEE=as.character(ANNEE)
      ) |>
      group_by(VILLE) |>
      summarise(PrixMoy=round(mean(PRIX,na.rm = TRUE),4),
                VarMoy=round(mean(TauxVar,na.rm =TRUE),4),
                VarMoyAbs=round(mean(abs(TauxVar),na.rm =TRUE),4))
    
  })
  output$aRegionM <- renderLeaflet({
    # Indicateur_recap
    indicateurs_recap <- indicateurs_recap()
    indicateurs_recap0 <- left_join(indicateurs_recap,adressRegion1, by=c("VILLE"="value"))
    
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
  
 
  output$aRegionP <-  renderAmCharts({
    # Filtrer les données priceGlob en fonction du produit et de la date sélectionnés
    
    filtered_data <- priceGlob|>
      filterOption(input$wel_produit,"PRODUITS") |>
      filterOption(input$date,"ANNEE")
    # Créer un graphique de boîte à moustaches avec amBoxplot
    amBoxplot(PRIX ~ VILLE, data = filtered_data,
                   main = paste("Boîte à moustaches des prix des produits en fonction des années"),
                   xlab = "Ville", ylab = "Prix")
    
    
    
  })

  ###############################"
  #Tableau indicateur
  output$table <- renderDT({
    indicateurs_recap <- indicateurs_recap()
    datatable(indicateurs_recap, options = list(
      initComplete = JS(
        "function(settings, json) {",
        "$(this.api().table().header()).css({'background-color': '#FE8700', 'color': '#fff'});",
        "}")
    ))
    
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
    
    villes_min_indicateur0 <-  villes_min_indicateur|>select(VILLE,SPECIFICITE,!!selected_indicateur)
    
    villes_pivot <- villes_min_indicateur0 %>%
      pivot_wider(names_from = VILLE, values_from = !!sym(selected_indicateur),values_fn = ~mean(.x,na.rm=TRUE))
    
    datatable(villes_pivot, options = list(
      initComplete = JS(
        "function(settings, json) {",
        "$(this.api().table().header()).css({'background-color': '#FE8700', 'color': '#fff'});",
        "}")
    ))
    
  })
  
  ###########################################################################
  ## Analyse par DATE
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
