#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

fluidPage(
  theme = shinytheme("cerulean"),
  
  # Sidebar with a slider input for number of bins
  navbarPage(
    title = "",
    position = "fixed-top",
    tags$style(type="text/css",
               "body {
               padding-top: 60px;
               font-family: 'Trebuchet MS', Helvetica, sans-serif;
               }"),
    
    ########################################################################################################
    # Page 1 
    tabPanel(title = "Présentation",
             fluidPage(
               tags$head(
                 tags$style(
                   HTML(
                     "
                            .body_row {
                              background: linear-gradient(to bottom, #007bff, #ffffff); 
                            }
                            "
                   )
                 )
               ),
               
               fluidRow(
                 #Head
                 column(width = 3,
                        img(src="img/logoUFHB.jpg", title="Popup", width = "50%"),
                        img(src="img/logoUFR.jpg", title="Popup", width = "40%")
                 ),
                 column(width = 7,
                        h2("ANALYSE DES PRIX  DES PRODUITS ALIMENTAIRES SUR LES MARCHES IVOIRIENS", 
                           style = "
                             color :orange;
                             font-weight: bold;
                             text-align:center
                             "),
                 ),
                 
                 column(width = 2,
                        style="
                                    display: inline-flex;
                                    justify-content: space-evenly;",
                        img(src="img/AmoirCI.png",
                            title="Popup",
                            width = "60%"
                        )
                 )
                 
               ),
               fluidRow(
                 
                 #BODY
                 class="body_row",
                 style="
                   display: inline-flex;
                   justify-content: space-evenly;
                                    ",
                 # column(width = 1),
                 column(width = 6,
                        
                        br(), br(), br(),
                        h4("#LUTTE CONTRE LA CHERTE DE LA VIE",
                           style = "
                             color : white;
                             font-weight: bold;
                             font-size: 24px;
                             text-align:center"
                        ),
                        
                        br(),
                        p("Ce projet s’inspire des directives de l’Etat de Côte d’ivoire dans
                                  la lutte contre la cherté de la vie.", 
                          style = "
                            color : red;
                            font-size: 24px;
                            font-weight: bold ;
                            text-align:justify"
                        ),
                        br(),
                        p("Il offre un outil de restitution des prix des différentes
                                  denrées alimentaires dans les marchés, ainsi qu’une analyse portant sur leurs structures.", 
                          style = "
                            color : red;
                            font-size: 24px;
                            font-weight: bold;
                            text-align:justify"
                        )
                 ),
                 
                 # colonne 2
                 column(width =6,
                        style="
                          display: inline-flex;
                          justify-content: space-evenly;
                          width: 50%;",
                        img(src="img/marche.png",
                            title="Popup",
                            width="70%"
                        )
                 ),
                 
               ),
               fluidRow(
                 #Footer
                 
                 class="footer",
                 column(width = 4,
                        fluidRow(
                          column(width = 6,
                                 p("Amadou BAH",
                                   style = "color : black;
                                     font-size:19px;
                                     font-weight: bold;
                                     font-style: italic;
                                     "),
                                 p("Frederic AKADJE",
                                   style = "color : black;
                                     font-size: 19px;
                                     font-weight: bold;
                                     font-style: italic; 
                                     "),
                          ),
                          
                          column(width = 5,
                                 
                                 img(src="img/LogoLinkedin.png",
                                     title="Popup",
                                     width = "20%"),
                                 
                                 img(src="img/logoGithub.png",
                                     title="Popup",
                                     width = "20%"),
                                 
                                 img(src="img/logoGmail.png",
                                     title="Popup",
                                     width = "20%"),
                                 
                                 br(),
                                 img(src="img/LogoLinkedin.png",
                                     title="Popup",
                                     width = "20%"),
                                 
                                 img(src="img/logoGithub.png",
                                     title="Popup",
                                     width = "20%"),
                                 
                                 img(src="img/logoGmail.png",
                                     title="Popup",
                                     width = "20%"),
                          ),
                          column(width = 1,)
                          
                        )
                        
                 ),
                 
                 column(width = 8,
                        style="display: flex;
                                    justify-content: space-between;",
                        img(src="img/logoOpendata.png",
                            title="Popup",
                            width = "20%"),
                        
                        img(src="img/logoOcpv.png",
                            title="Popup",
                            width = "20%"),
                        
                        img(src="img/logoCnlvc.png",
                            title="Popup", 
                            width = "20%"),
                        
                        img(src="img/logoSikaF.png",
                            title="Popup",
                            width = "20%")
                 )
                 
               ),
             )),
    #######################################################################################################
    #Page prix actuel
    tabPanel(title = "Prix du marché",
             fluidRow(
               style = "justify-content: space-evenly;",
               column(
                 width=2,
                 img(src="img/PanierFruits.png",
                     title="Popup",
                     width = "100%",
                     heigth="100%")
               ),
               column(
                 width=8,
                 div(
                   style="margin:10px 60px 30px 60px; text-align:center",
                   h3(
                     style = "background-color: #FFFFFF;
                          font-size: 28px;
                          font-weight:bold;
                          text-align:center;
                          color:orange;",
                                
                     "PRIX DES PRODUITS DE GRANDE CONSOMMATION"),
                   p(
                     style = "background-color: #FFFFFF;
                        font-size: 18px;
                        text-align:center;",
                     "Consultez l'évolution des prix actuels du marchés les principales villes de la Côte d'Ivoire."),
                   p("(Le chargement des ressources se fait depuis le site de la SIKAfinances et peut prendre quelques du temps...)"),
                   
                   
                 ),
               ),
               column(
                 width=2,
                 img(src="img/PanierLegume.jpg",
                     title="Popup",
                     width = "100%",
                     heigth="100%")
               )
             ),
             withSpinner(DTOutput(outputId = "table_prix"), type = 6),
             fluidRow(
               #Footer
               
               class="footer",
               column(width = 4,
                      fluidRow(
                        column(width = 6,
                               p("Amadou BAH",
                                 style = "color : black;
                                     font-size:19px;
                                     font-weight: bold;
                                     font-style: italic;
                                     "),
                               p("Frederic AKADJE",
                                 style = "color : black;
                                     font-size: 19px;
                                     font-weight: bold;
                                     font-style: italic; 
                                     "),
                        ),
                        
                        column(width = 5,
                               
                               img(src="img/LogoLinkedin.png",
                                   title="Popup",
                                   width = "20%"),
                               
                               img(src="img/logoGithub.png",
                                   title="Popup",
                                   width = "20%"),
                               
                               img(src="img/logoGmail.png",
                                   title="Popup",
                                   width = "20%"),
                               
                               br(),
                               img(src="img/LogoLinkedin.png",
                                   title="Popup",
                                   width = "20%"),
                               
                               img(src="img/logoGithub.png",
                                   title="Popup",
                                   width = "20%"),
                               
                               img(src="img/logoGmail.png",
                                   title="Popup",
                                   width = "20%"),
                               
                        ),
                        column(width = 1,)
                        
                      )
                      
               ),
               
               column(width = 8,
                      style="display: flex;
                                    justify-content: space-between;",
                      img(src="img/logoOpendata.png",
                          title="Popup",
                          width = "20%"),
                      
                      img(src="img/logoOcpv.png",
                          title="Popup",
                          width = "20%"),
                      
                      img(src="img/logoCnlvc.png",
                          title="Popup", 
                          width = "20%"),
                      
                      img(src="img/logoSikaF.png",
                          title="Popup",
                          width = "20%")
               )
               
             ),
    ),
    
    ############################################################################################
    
    
    
    # Page 3
    tabPanel(title = "Analyse par date",
             
             # Sidebar page 2
             sidebarPanel("SIDEBAR Page 2", width = 3,
                          
                          
                          div(
                            style = "background-color: #A09D9E; padding: 15px; margin-bottom: 15px;",
                            selectizeInput(inputId = "wel_indicateur",
                                           label = "Choisir un indicateur: ",
                                           selected = "Prix Moyen",
                                           choices = c("Prix Moyen",
                                                       "Taux de variat. moy.",
                                                       "Taux de variat. moy. (absolu)"))
                          ),
                          
                          
                          div(
                            style = "background-color: #478FFC; padding: 15px; margin-bottom: 15px;",
                            selectizeInput(inputId = "wel_ville",
                                           label = "Ville: ",
                                           selected = NULL,
                                           choices = uniqueVille),
                            # DatasetPrice$VILLE)
                          ),
                          
                          
                          div(
                            style = "background-color:#50FC47; padding: 15px; margin-bottom: 15px;",
                            
                            selectizeInput(inputId = "wel_categorie",
                                           label = "Categorie: ",
                                           selected = NULL,
                                           choices = uniqueCateg),
                            
                            selectizeInput(inputId = "wel_SousCat",
                                           label = "Sous-catégorie: ",
                                           selected = NULL,
                                           choices = uniqueSousCat),
                            
                            selectizeInput(inputId = "wel_Specificite",
                                           label = "Spécificté ",
                                           selected = NULL,
                                           choices = uniqueSpecifite),
                            
                            
                            selectizeInput(inputId = "wel_produit", label = "Produits: ",
                                           selected = NULL,
                                           choices = uniqueProd)
                          ),
                          
                          div(
                            style = "background-color: #FCE147; padding: 15px; margin-bottom: 15px;",
                            selectizeInput(inputId = "wel_date",
                                           label = "Annee: ",
                                           selected = NULL,
                                           choices = uniqueAnnee)
                            # choices = DatasetPrice$ANNEE)
                          )
                          
             ),
             
             # Menu principal page 2
             mainPanel(
               # Tabset page 2
               tabsetPanel(
                 
                 # TabPanel 1
                 tabPanel("Général",
                          style = "width:1060px",
                          div(
                            style = "background-color: #FFFFFF;
                            padding: 10px;
                            font-size: 14px;
                             text-align:justify;
                            font-family: 'Trebuchet MS', Helvetica, sans-serif;
                            border: none;
                            border-radius: 10px;
                            box-shadow: 0px 0px 5px rgba(0, 0, 0, 0.3);
                            ",
                            textOutput(outputId = "wel_texteAfficheTimesSeries1")
                          ),
                          br(style = "width: 0.5px;"),
                          # Grandes séries temporelles
                          fluidRow(
                            style = "background-color: #FFFFFF;
                            padding: 10px;
                            font-size: 18px;
                             text-align:justify;
                            font-family: 'Trebuchet MS', Helvetica, sans-serif;
                            border: none;
                            border-radius: 10px;
                            box-shadow: 1px 1px 5px rgba(0, 0, 0, 0.3);
                            ",
                            column(width=12,
                                   withSpinner(dygraphOutput("wel_dygraph"),type=1,
                                               color = getOption("spinner.color", default = "pink")
                                   ),
                            ),
                          
                          ),
                          br(),
                          fluidRow(
                              column(
                                div(
                                  style = "background-color: #FFFFFF;
                            padding: 10px;
                            font-size: 18px;
                             text-align:justify;
                            font-family: 'Trebuchet MS', Helvetica, sans-serif;
                            border: border: none;
                            border-radius: 10px;
                            box-shadow: 1px 1px 5px rgba(0, 0, 0, 0.3);
                            ",
                                  withSpinner(dygraphOutput("wel_dygraphMois"),type=1,
                                              color = getOption("spinner.color", default = "pink")
                                  ),
                                  
                                  p("Différentes tendances sont observées d'une année, à une autre.
                                  Ces irrégularités sont marquées par des prix plus élévés sur la période 2021, et 
                                  moins volatiles sur le début de l'année 2022."
                                    )
                                  
                                ),
                                width=7,
                              ),
                              
                              column(
                                style = "background-color: #FFFFFF;
                            padding: 20px;
                            font-size: 18px;
                             text-align:justify;
                            font-family: 'Trebuchet MS', Helvetica, sans-serif;
                            border: border: none;
                            border-radius: 10px;
                            box-shadow: 1px 1px 5px rgba(0, 0, 0, 0.3);
                            ",
                                width=5,
                                h4(style = 
                                  "color: black;
                                  font-family:16px;
                                   font-weight:bold;
                                   text-align:justify;",
                                  
                                   textOutput("wel_TitleTableSaiRecap")),
                                withSpinner(gt_output(outputId = "wel_tableSaiRecap1"),
                                            type=1,
                                            color = getOption("spinner.color", default = "pink"))
                              )
                            ),
                          
                          ),
                 
                 # TabPanel 2
                 tabPanel("Saisonnalité",
                          style = "width:1060px",
                          div(
                            style = "background-color: #FFFFFF;
                            padding: 10px;
                            font-size: 18px;
                             text-align:justify;
                            font-family: 'Trebuchet MS', Helvetica, sans-serif;
                            border: 1px solid #000000;
                            border-left: none;
                            border-right: none;
                            border-radius: 10px;
                            box-shadow: 0px 0px 5px rgba(0, 0, 0, 0.3);
                            ",
                            p("Le mixage aléas climatique
                            rencontrés suivant les périodes étudiées, donnent lieu à des
                             disparités significatives au niveau des produits 
                             selon différentes périodes de l'année. Ainsi certains produits
                             sont plus accessibles selon certaines périodes de l'années. L'accessibilité ici
                             se mesure par le taux de variation moyen. Un produit sera plus accessibilité s'il détient le plus petit 
                             taux de variation sur la période concernée.
                            "),
                          ),
                          br(),
                          fluidRow(
                            style = "background-color: #FFFFFF;
                            padding: 10px;
                            font-family: 'Trebuchet MS', Helvetica, sans-serif;
                            border: none;
                            border-radius: 10px;
                            box-shadow: 1px 1px 5px rgba(0, 0, 0, 0.3);
                            ",
                            column(width=10,
                                   withSpinner(dygraphOutput("wel_dygraphSai"),
                                               type = 1,
                                               color = getOption("spinner.color", default = "pink")
                                   )  ),
                            column(width=2,
                                   div(
                                     br(),
                                     p(style = "background-color: #FFFFFF;
                                        
                                        font-size: 16px;",
                                     "Les Différents se font ici par rapport aux
                                       semestre des différentes années marqués aux couleur alternées. 
                                       "),
                                     p(
                                       style = "background-color: #FFFFFF;
                                       color: green;
                                        
                                        font-size: 16px;",
                                       "(Survolez les zones de textes, dans le graphique afin d'avoir
                                       une meilleur lecture des produits)
                                       ")
                                     
                                   )
                            )
                          ),
                          
                          br(),
                          div(
                            style = "background-color: #FFFFFF;
                            padding: 10px;
                            font-size: 18px;
                             text-align:justify;
                            border: none;
                            border-radius: 10px;
                            box-shadow: 1px 1px 5px rgba(0, 0, 0, 0.3);
                            ",
                            h4(style = 
                                 "color: black;
                                  font-family:16px;
                                   font-weight:bold;
                                   text-align:center;",
                               
                               p("CARACTERE SAISONNEL ET CYCLIQUE DES PRIX")),
                            withSpinner(gt_output(outputId = "wel_tableSai"),type=1,
                                        color = getOption("spinner.color", default = "pink")
                            ),
                            p("L'intensité des couleurs ici est proportionnelle à l'importance
                            du prix sur les périodes observées (par ligne).
                              Une hausse des prix apparaît régulièrement en fin d'années et se poursuit jusqu'au milieu du premier trimestre (voir zones en rouge). Ainsi
                              Malgré des perturbations observées, une distinction d'un critère saisonnel cyclique des prix
                              au cours des années."
                              )
                          ),
                          
                          
                          
                 ),
                 tabPanel("Recap",
                          style = "width:1060px",
                          
                          div(
                            style = "background-color: #FFFFFF;
                            padding: 10px;
                            font-size: 18px;
                             text-align:justify;
                            font-family: 'Trebuchet MS', Helvetica, sans-serif;
                            border: 1px solid #000000;
                            border-left: none;
                            border-right: none;
                            border-radius: 10px;
                            box-shadow: 0px 0px 5px rgba(0, 0, 0, 0.3);
                            ",
                            p("Les aléas climatiques et évènements extraordinaires
                            rencontrés suivant les périodes étudiées, donnent lieu à des
                             disparités significatives au niveau des produits 
                             d'une années à une autre. 
                            ")
                          ),
                          
                          br(),
                          fluidRow(
                            
                            column(
                              width=6,
                              p(
                                style = "background-color: #FFFFFF;
                                  padding: 10px;
                                  font-size: 21px;
                                  font-weight: bold;
                                  color:pink;
                                  text-align:center;
                                ",
                                "PRODUITS LES PLUS ACCESSIBLES SELON LES PERIODES DES ANNEES 
                                "),
                              withSpinner(gt_output(outputId = "wel_tableSaiRecap"),type=1,
                                          color = getOption("spinner.color", default = "#F13DF1")
                                          # ),    
                              ),
                            ),
                            column(
                              width=6,
                              img(src="img/PanelFruits.png",
                                  title="Panel de fruits et légumes",
                                  width = "100%",
                                  heigth="100%"),
                              p(
                                style = "background-color: #FFFFFF;
                                  padding: 10px;
                                  font-size: 18px;
                                  text-align:justify;
                                ",
                              "Le classement obtenu est relatif aux produits 
                                les plus accessibles selon les périodes des 
                                différentes années concernées. L'accessibilté ici
                                est mésurée à travers le taux de variation de la catégorie,
                                de la spécificté ou du produits, sur la pérode observées.\n
                                Ainsi selon l'axe étudié (catégorie,spécificté ou produits),
                                les meilleurs composants seront constitués des éléments ayant
                                le plus petit taux de variation du prix. 
                                
                                ")
                            )
                          )
                          
                          
                 )
               )
               
             ),
    ),
    #######################################################################################################
    # Page 4
    tabPanel(title = "Analyse par région",
             fluidRow(
               column(width = 12,
                      # Sidebar page 2
                      sidebarPanel("SIDEBAR Page 2", width = 3,
                                   
                                   div(
                                     style = "background-color: #A09D9E; padding: 15px; margin-bottom: 15px;",
                                     selectizeInput(inputId = "indicateur", label = "Choisir un indicateur: ", selected = colnames(indicateurs_recap)[2],
                                                    choices = colnames(indicateurs_recap)[2:4])
                                   ),
                                   
                                   
                                   div(
                                     style = "background-color: #478FFC; padding: 15px; margin-bottom: 15px;",
                                     selectizeInput(inputId = "ville", label = "Ville: ", selected = NULL,
                                                    choices = uniqueVille)
                                   ),
                                   
                                   
                                   div(
                                     style = "background-color:#50FC47; padding: 15px; margin-bottom: 15px;",
                                     
                                     selectizeInput(inputId = "Specificite", label = "Specificite: ", selected = NULL,
                                                    choices = uniqueSpecifite),
                                     
                                     selectizeInput(inputId = "produit", label = "Produits: ", selected = NULL,
                                                    choices = uniqueProd)
                                   ),
                                   
                                   div(
                                     style = "background-color: #FCE147; padding: 15px; margin-bottom: 15px;",
                                     selectizeInput(inputId = "date", label = "Annee: ", selected = NULL,
                                                    choices =uniqueAnnee )
                                   )
                                   
                      ),
                      
                      
                      
                      # Menu principal page 2
                      mainPanel(
                        # Tabset page 2
                        
                        tabsetPanel(
                          
                          # TabPanel 1
                          tabPanel("Général",
                                   style = "width:1060px;",
                                   
                                   div(
                                     style = "background-color: #FFFFFF;
                                          padding: 10px;
                                          font-size: 14px;
                                           text-align:justify;
                                          font-family: 'Trebuchet MS', Helvetica, sans-serif;
                                          border: none;
                                          border-radius: 10px;
                                          box-shadow: 0px 0px 5px rgba(0, 0, 0, 0.3);",
                                     
                                     # Affichage du texte basé sur la sélection
                                     
                                     p(style="text-align:justify;font-size: 10px;",
                                       textOutput(outputId = "bah_texteAffichePage2")
                                     )
                                     
                                     
                                   ),
                                   br(),
                                   fluidRow(
                                     style = "background-color: #FFFFFF;
                                          padding: 10px;
                                          font-size: 18px;
                                           text-align:center;
                                          font-family: 'Trebuchet MS', Helvetica, sans-serif;
                                          border: none;
                                          border-radius: 10px;
                                          box-shadow: 0px 0px 5px rgba(0, 0, 0, 0.3);",
                                     column(width = 6,
                                            div(
                                              h4(textOutput("bah_Titlecarte1")),
                                              withSpinner(leafletOutput("aRegionM",
                                                                        width = "100%",
                                                                        height = 450),
                                                          type = 6),
                                              p(style="text-align:justify;font-size: 14px;",
                                                " L’intensité des couleurs sur les cartes est proportionnelle
                                    à la valeur prise par l’indicateur. Les aproximations des prix sur toute l’étendue du 
                                    térritoire se fait aux moyens de prévisions de prix selon leur proximité.")
                                              
                                            ),
                                     ),
                                     column(
                                       width = 6,
                                       div(
                                         h4(style="text-align:center;",
                                            "DISTRIBUTION DES PRIX SELON LES VILLES DE BASES"),
                                         withSpinner(amChartsOutput("aRegionP",
                                                                    width = "100%",
                                                                    height = "525px"),
                                                     type = 6)),
                                     ),
                                     
                                   ),
                                   column(width = 12,
                                          div(
                                            style = "background-color: #FFFFFF; text-align:center;padding:10px",
                                            h4("INDICATEURS SELON LES VILLES DE BASE"),
                                            withSpinner(DTOutput("table"), type = 6),
                                          ))
                          ),
                          
                          # TabPanel 2
                          tabPanel("Rechercher", 
                                   style = "width:1060px",
                                   fluidRow(
                                     style = "background-color: #FFFFFF;
                                      padding: 10px;
                                      font-size: 18px;
                                       text-align:justify;
                                      font-family: 'Trebuchet MS', Helvetica, sans-serif;
                                      border: none;
                                      border-radius: 10px;
                                      box-shadow: 0px 0px 5px rgba(0, 0, 0, 0.3);",
                            
                                     column(width = 7,
                                            div(
                                              h4("REPARTITION DES SPECIFICITES DES PRODUITS LES PLUS ACCESSIBLES SELON LES REGIONS"),
                                              withSpinner(leafletOutput("aRegionMr"), type = 6)
                                              ,
                                            ),
                                     ),
                                     
                                     column(width = 5,
                                            style = "padding: 15px ;
                                            padding: 10px;",
                                            div(
                                              p(" Les prix moyens des denrées alimentaires en Côte d’Ivoire présentent des disparités
                                       significatives d’une région à l’autre. Cette inégalité de répartition s’explique par plusieurs
                                       facteurs endogènes, c’est-à-dire des facteurs internes au pays et au système économique.
                                         Parmi ces facteurs, on peut citer:"),
                                              p("- Différences de production agricole"),
                                              p("- Difficultés d’accès aux marchés"),
                                              p("- Facteurs de demande "),
                                              p("- Politiques gouvernementales"),
                                            )
                                            
                                     ),
                                     
                                   ),
                                   column(width = 12,
                                          div(
                                            style="margin-top:50px; text-align:center",
                                            h4("SPECIFICTE DES PRODUITS EN FONCTION DES VILLES DE BASE SELON L'INDICATEUR"),
                                            withSpinner(DTOutput(outputId = "table2"), type = 6)
                                            
                                          ),
                                   )
                                   
                          )
                        )
                      )
                      
               ))),
    
    #########################################################################################################
  ))