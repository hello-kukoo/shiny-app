library(shiny)

histogramUI <- function(id) {
  ns <- NS(id)
  tagList(
    selectInput(ns("var"), "Variable", names(mtcars)),
    numericInput(ns("bins"), "bins", 10, min = 1),
    plotOutput(ns("hist")),
  )
}

histogramServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    data <- reactive(mtcars[[input$var]])
    output$hist <- renderPlot({
      hist(data(), breaks = input$bins, main = input$var)
    }, res = 96)
  })
}
