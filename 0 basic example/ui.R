library(shiny)

shinyUI(pageWithSidebar(
  
  # Application title
  headerPanel("New Application"),
  
  # Sidebar with a slider input 
  # for number of observations
  sidebarPanel(
    sliderInput("obs", 
      "Number of observations:", 
      min = 1, 
      max = 1000, 
      value = 500)
  ),
  
  # Show a plot of the generated 
  # distribution
  mainPanel(
    plotOutput("distPlot")
  )
))



a = 1
b = 1
c = a + b
a = 2 #even though I changed the value of a, the value of c remained unchanged

