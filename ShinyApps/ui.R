#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    https://shiny.posit.co/
#

library(shiny)
library(plotly)
library(bslib)

# Define UI for application that draws a histogram
fluidPage(

    # Application title
    # titlePanel("Old Faithful Geyser Data"),

    # Sidebar with a slider input for number of bins
    navbarPage(
      title = "",
      # Page 1 
      tabPanel(title = "Présentation",
               fluidPage(
                 tags$head(
                   tags$style(
                     HTML(
                       "
                            .body_row {
                            
                            height:410px;
                            width:103%;
                            margin-rigth:100px;
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
                             style = "color :orange;font-weight: bold;text-align:center"),
                   ),
                   
                   column(width = 2,
                          style="
                                    display: inline-flex;
                                    justify-content: space-evenly;",
                          img(src="img/AmoirCI.png", title="Popup", width = "60%")
                   )
                   
                 ),
                 fluidRow(
                   #BODY
                   class="body_row",
                   column(width = 1,),
                   column(width = 4,
                          
                          br(), br(), br(),
                          h4("#LUTTE CONTRE LA CHERTE DE LA VIE", style = "color : black;font-weight: bold;text-align:center"),
                          br(),
                          p("Ce projet s’inspire des directives de l’Etat de Côte d’ivoire dans
                                  la lutte contre la cherté de la vie.", 
                            style = "color : orange;font-size: 20px;font-weight: bold ;text-align:center"),
                          br(),
                          p("Il offre un outil de restitution des prix des différentes
                                  denrées alimentaires dans les marchés, ainsi qu’une analyse portant sur leurs structures.", 
                            style = "color : orange;font-size: 20px; font-weight: bold;text-align:center")
                   ),
                   
                   # colonne 2
                   column(width =7,
                          style="
                                    display: inline-flex;
                                    justify-content: space-evenly;
                                    width: 50%;",
                          img(src="img/marche.png", title="Popup", width="70%")
                   ),
                   
                 ),
                 fluidRow(
                   #Footer
                   
                   class="footer",
                   column(width = 4,
                          fluidRow(
                            column(width = 6,
                                   p("BAH AMADOU ALI",style = "color : black;font-size:20px;font-weight: bold;font-style: italic;"),
                                   p("AKADJE FREDERIC",style = "color : black;font-size: 20px;font-weight: bold;font-style: italic; "),
                            ),
                            column(width = 5,
                                   
                                   img(src="img/LogoLinkedin.png", title="Popup", width = "20%"),
                                   
                                   img(src="img/logoGithub.png", title="Popup", width = "20%"),
                                   
                                   img(src="img/logoGmail.png", title="Popup", width = "20%"),
                                   br(),
                                   img(src="img/LogoLinkedin.png", title="Popup", width = "20%"),
                                   
                                   img(src="img/logoGithub.png", title="Popup", width = "20%"),
                                   
                                   img(src="img/logoGmail.png", title="Popup", width = "20%"),
                                   
                            ),
                            column(width = 1,)
                            
                          )),
                   
                   column(width = 8,
                          style="display: flex;
                                    justify-content: space-between;",
                          img(src="img/logoOpendata.png", title="Popup", width = "20%"),
                          img(src="img/logoOcpv.png", title="Popup", width = "20%"),
                          img(src="img/logoCnlvc.png", title="Popup", width = "20%"),
                          img(src="img/logoSikaF.png", title="Popup", width = "20%")
                   )
                   
                 ),
               )),
      
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
      
      # Page 3
      tabPanel(title = "Analyse par date",
               
               # Sidebar page 3
               sidebarPanel("SIDEBAR Page 3", width = 2),
               mainPanel(
                 tabsetPanel(
                   
                   tabPanel("Général",
                            "Menu Général"),
                   
                   tabPanel("Saisonnalité",
                            "Menu Saisonnalité")
                 )
               )
               )
    )
)
