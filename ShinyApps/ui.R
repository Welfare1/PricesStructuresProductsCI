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
               "Page de présentation"),
      
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
