library(shiny)

shinyview <- function(df) {
	runApp(list(
	  ui = basicPage(
	    h2('Data Explorer'),
	    dataTableOutput('mytable')
	  ),
	  server = function(input, output) {
	    output$mytable = renderDataTable({
	      df
	    }, options = list(iDisplayLength = 10))
	  }
	))	
}

shinyview(mtcars)