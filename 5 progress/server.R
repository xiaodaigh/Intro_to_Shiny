
library(shiny)

shinyServer(function(input, output,session) {
   
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
    
    withProgress(session, min=0, max=10, {
      setProgress(message = 'Processing ...',
                  detail = 'This may take a few minutes...')                
      setProgress(value = 3)
      rnorm(10000000)
      
      setProgress(message = 'Processing2 ...',
                  detail = 'This may take a few minutes...')                
      setProgress(value = 6)
      rnorm(10000000)

      # generate and plot an rnorm distribution with the requested
      # number of observations
      
      #dist <- rnorm(input$obs)
      if(input$actionButton1 ==0) return()
      isolate({
        dist <- random_sample()
        hist(dist)
      })
      setProgress(value = 10)
      rnorm(1000000)
    })
  })
})
