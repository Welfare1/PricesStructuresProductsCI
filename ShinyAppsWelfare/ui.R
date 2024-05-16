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
             sidebarPanel(
                          selectInput(inputId = "wel_selIndic",
                                      label = "Indicateur: ",
                                      selected = 1,
                                      choices = c("Prix moyen" = 1,
                                                  "Taux de variation moyen" = 2,
                                                  "Taux de variation moy (abs)" = 3)
                                      ),
                          selectInput(inputId = "wel_selAnnee",
                                      label = "Année: ",
                                      selected = 1,
                                      choices = c("2020" = 1,
                                                  "2021" = 2,
                                                  "2022" = 3)
                          ),
                          dateRangeInput(
                            inputId= "wel_selDateRange",
                            start="2020-01-01",
                            end = "2023-01-01",
                            language = "fr",
                            label = "Plage date :"),
                          
                          selectInput(inputId = "wel_selMois",
                                      label = "Mois : ",
                                      selected = NULL,
                                      choices = c("Janvier", "Février", "Mars", "Avril", "Mai", "Juin",
                                                  "Juillet", "Août", "Septembre", "Octobre", "Novembre", "Décembre")
                          ),
                          
                          selectInput(inputId = "wel_semaine",
                                      label = "Semaine : ",
                                      selected = NULL,
                                      choices = str_c("Semaine ", 1:52)
                          ),
                          
                          selectInput(inputId = "wel_ville",
                                      label = "Ville : ",
                                      selected = NULL,
                                      choices = str_c("Ville ", 1:6)
                          ),
                          
                          selectInput(inputId = "wel_Categorie",
                                      label = "Catégorie : ",
                                      selected = NULL,
                                      choices = str_c("Catégorie ", 1:9)
                          ),
                          
                          selectInput(inputId = "wel_produit",
                                      label = "Produit : ",
                                      selected = NULL,
                                      choices = str_c("Produit ", 1:20)
                          ),
                          
                                         
                                        
                          # Largeur du panel
                          width = 2
                          ),
             
             # Menu principal page 2
             mainPanel(
               # Tabset page 2
               tabsetPanel(
                 
                 # TabPanel 1
                 tabPanel("Général",
                          # Grandes séries temporelles
                          fluidRow(
                            column(width=11,
                                   dygraphOutput("wel_dygraph")),
                            column(width=1,
                                   "Commentaire")
                          ),
                          fluidRow(
                            column(width=8,
                                   dygraphOutput("wel_dygraphMois")),
                            column(width=4,
                                   "Commentaire")
                          )
                          
                 ),
                 
                 # TabPanel 2
                 tabPanel("Saisonnalité", 
                          fluidRow(
                            column(width=11,
                                   dygraphOutput("wel_dygraphSai")),
                            column(width=1,
                                   "Commentaire")
                          ),
                          
                 )
               )
             )
             
    ),
    
    #########################################################################################################"""
    
  )
)
