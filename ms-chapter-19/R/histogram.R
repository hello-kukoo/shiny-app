library(shiny)

histogramUI <- function(id) {
  ns <- NS(id)
  tagList(
    selectInput(ns("var"), "Variable", names(mtcars)),
    numericInput(ns("bins"), "bins", 10, min = 1),
    plotOutput(ns("hist")),
  )
}

histogramBins <- function(id) {
  ns <- NS(id)
  numericInput(ns("bins"), "bins", 10, min = 1, step = 1)
}

histogramOutput <- function(id) {
  ns <- NS(id)
  plotOutput(ns("hist"))
}

histogramServer <- function(id, x, title = reactive("Histogram")) {
  stopifnot(is.reactive(x))
  stopifnot(is.reactive(title))

  moduleServer(id, function(input, output, session) {
    output$hist <- renderPlot({
      # req(is.numeric(x))
      main <- paste0(title(), " [", input$bins, "]")
      hist(x(), breaks = input$bins, main = main)
    }, res = 96)
  })
}
