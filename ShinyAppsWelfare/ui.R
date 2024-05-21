#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#



fluidPage(
  # Sidebar with a slider input for number of bins
  navbarPage(
    title = "",
    position = "fixed-top",
    tags$style(type="text/css",
               "body {padding-top: 70px;}"),
    
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
                             color :#f77605;
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
                            color : #f77605;
                            font-size: 24px;
                            font-weight: bold ;
                            text-align:justify"
                        ),
                        br(),
                        p("Il offre un outil de restitution des prix des différentes
                                  denrées alimentaires dans les marchés, ainsi qu’une analyse portant sur leurs structures.", 
                          style = "
                            color : #f77605;
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
    # Page 2
    tabPanel(title = "Analyse par région",
             
             # Sidebar page 2
             sidebarPanel("SIDEBAR Page 2", width = 2),
             
             # Menu principal page 2
             mainPanel(
               # Tabset page 2
               tabsetPanel(
                 
                 # TabPanel 1
                 tabPanel("Général", 
                          "Menu Général"
                 ),
                 
                 # TabPanel 2
                 tabPanel("Rechercher", 
                          "Menu Rechercher"
                          
                 )
               )
             )
             
    ),
    
    #######################################################################################################
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
                            font-size: 18px;
                             text-align:justify;
                            font-family: 'Trebuchet MS', Helvetica, sans-serif;
                            border: 1px solid #000000;
                            border-left: none;
                            border-right: none;
                            border-radius: 10px;
                            box-shadow: 0px 0px 5px rgba(0, 0, 0, 0.3);
                            ",
                            p("Trois indicateurs sont utilisés dans la mise en évidence des différentes variations
                                des prix selon les régions. L’intensité des couleurs sur les cartes est proportionnelle
                                à la valeur prise par l’indicateur. Les aproximations des prix sur toute l’étendue du 
                                térritoire se fait aux moyens de prévisions de prix selon leur proximité")
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
                            column(width=10,
                                   dygraphOutput("wel_dygraph")),
                            column(width=2,
                                   "Commentaire")
                          ),
                          # Séries temporelles des produits par saison
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
                               dygraphOutput("wel_dygraphMois"),
                               p("La palettte verte désigne les zones au prix moyen en dessous du prix moyen général.
                                         A contrario, 
                                 une couleur rouge désignera les zones aux moyen dépassant le prix moyen global.")
                            
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
                              withSpinner(gt_output(outputId = "wel_tableSaiRecap1"),
                                          type=1,
                                          color = getOption("spinner.color", default = "pink"))
                                   )
                          )
                     
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
                            p("Trois indicateurs sont utilisés dans la mise en évidence des différentes variations
                                des prix selon les régions. L’intensité des couleurs sur les cartes est proportionnelle
                                à la valeur prise par l’indicateur. Les aproximations des prix sur toute l’étendue du 
                                térritoire se fait aux moyens de prévisions de prix selon leur proximité")
                          ),
                          br(),
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
                            column(width=9,
                                  withSpinner(dygraphOutput("wel_dygraphSai"),
                                              type = 1,
                                              color = getOption("spinner.color", default = "pink")
                                              )  ),
                            column(width=3,
                                   div(
                                     radioButtons(inputId = "wel_selectSai",
                                                  label = "Retrouver",
                                                  selected = "Region",
                                                  choices = c("region", "Une culture" )
                                     ),
                                     
                                     selectizeInput(inputId = "wel_indicateurSai",
                                                    label = "Choisir un indicateur: ",
                                                    selected = "indicateur1",
                                                    choices = c("indicateur1", "indicateur2", "indicateur3")),
                                     
                                     actionButton(inputId = "wel_submit", label = "Obtenir")
                                     
                                   )
                                   )
                          ),
                         
                          br(),
                          div(
                            style = "background-color: #FFFFFF;
                            padding: 10px;
                            font-size: 18px;
                             text-align:justify;
                            font-family: 'Trebuchet MS', Helvetica, sans-serif;
                            border: none;
                            border-radius: 10px;
                            box-shadow: 1px 1px 5px rgba(0, 0, 0, 0.3);
                            ",
                            withSpinner(gt_output(outputId = "wel_tableSai"),type=1,
                                        color = getOption("spinner.color", default = "pink")
                            ),
                            p("Trois indicateurs sont utilisés dans la mise en évidence des différentes variations
                                des prix selon les régions. ")
                          ),
                          
                          
                          
                 ),
                 tabPanel("Recap",
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
                            p("Trois indicateurs sont utilisés dans la mise en évidence des différentes variations
                                des prix selon les régions. L’intensité des couleurs sur les cartes est proportionnelle
                                à la valeur prise par l’indicateur. Les aproximations des prix sur toute l’étendue du 
                                térritoire se fait aux moyens de prévisions de prix selon leur proximité")
                          ),
                          br(),
                          style = "width:1060px",
                          gt_output(outputId = "wel_tableSaiRecap") 
                          
                 )
               )
             )
             
    ),
    
    #########################################################################################################"""
    
  )
)
