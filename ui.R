#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
# 
#    http://shiny.rstudio.com/
#


library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
  
  # Application title
  titlePanel("Passing Against SFU"),
  
  # Sidebar with a slider input for number of bins 
  sidebarLayout(
    sidebarPanel(
       selectInput("dfSelect", "Choose Game",
                   c("Season Totals"="ovr",
                     "Week 3 South Dakota"="wk3",
                     "Week 4 Azusa Pacific" = "wk4")),
       actionButton("click","Game Selected"),
       
       selectInput("prefOvrPlot","Select Overall Plot Subject",
                   c("Yards"="yds",
                     "Completion %"="cmpprc",
                     "Attempts"="attempts",
                     "Completions"="completions"))

    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      tabsetPanel(
        tabPanel("Overall", tableOutput("overall")),
        tabPanel("Pocket Passing", tableOutput("pocketpass")),
        tabPanel("Play-Action", tableOutput("PAPass")),
        tabPanel("Out-of-Pocket Pass", tableOutput("OOPPass")),
        tabPanel("Red Zone", tableOutput("RZPass"))
      ),
      plotOutput("distPlot")
    )
  )
))
