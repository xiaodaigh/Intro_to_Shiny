library(shiny)

shinyServer(function(input, output) {
  
  output$distPlot1 <- renderPlot({
  	if(input$actionButton1 > 0) {
	    # generate and plot an rnorm distribution with the requested
	    # number of observations
	  	dist <- rnorm(input$obs)
	    hist(dist)
	}
  })
  
  output$distPlot2 <- renderPlot({
  	if(input$actionButton1 > 0) {
  		isolate({
		    # generate and plot an rnorm distribution with the requested
		    # number of observations
		  	dist <- rnorm(input$obs)
		    hist(dist)
	    })
	}
  })

  output$distPlot3 <- renderPlot({
  	if(input$actionButton1 == 0) return()
  	isolate({
	    # generate and plot an rnorm distribution with the requested
	    # number of observations
	  	dist <- rnorm(input$obs)
	    hist(dist)
	})
  })
})
