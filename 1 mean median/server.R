
library(shiny)

shinyServer(function(input, output) {
   
  random_sample <- reactive({
  	rnorm(input$obs )
  })
  
  median_rm <- reactive({
  	median(random_sample())
  })
  
  mean_rm <- reactive({
  	mean(random_sample())
  })
  
  output$summary <- renderPrint({
  	print(paste("The random sample Median:", format(median_rm(),digits=2)))  	
  	print(paste("The random sample Mean:", format(mean_rm(),digits=2)))
  })
	
  output$distPlot <- renderPlot({
     
    # generate and plot an rnorm distribution with the requested
    # number of observations
    
  	#dist <- rnorm(input$obs)
  	dist <- random_sample()
    hist(dist)
    
  })
  
})

