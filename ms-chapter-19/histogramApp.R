library(shiny)

histogramApp <- function() {
  app_ui <- fluidPage(histogramUI("hist1"))

  app_server <- function(input, output, session) {
    histogramServer("hist1")
  }

  shinyApp(ui = app_ui, server = app_server)
}

histogramApp()
