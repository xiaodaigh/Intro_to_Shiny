
# This is the user-interface definition of a Shiny web application.
# You can find out more about building applications with Shiny here:
# 
# http://www.rstudio.com/shiny/
#

library(shiny)
library(shinyIncubator)

shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("New Application"),
  
  # Sidebar with a slider input for number of observations
  sidebarPanel(
    sliderInput("obs", 
                "Number of observations:", 
                min = 1, 
                max = 1000, 
                value = 500)
    ,    br(),
    actionButton("actionButton1","Calculate")
    
  ),
  
  # Show a plot of the generated distribution
  mainPanel(
    progressInit(),
  	verbatimTextOutput("summary"),
  	br(),
    plotOutput("distPlot"),
  	plotOutput("distPlot2")
  )
))
