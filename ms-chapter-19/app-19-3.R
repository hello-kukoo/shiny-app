library(shiny)
library(zeallot)
library(purrr)
library(dplyr)

datasetInput <- function(id, filter = NULL) {
  ns <- NS(id)

  names <- ls("package:datasets")
  if (!is.null(filter)) {
    data <- lapply(names, get, "package:datasets")
    names <- names[vapply(data, filter, logical(1))]
  }

  selectInput(ns("dataset"), "Pick a dataset", choices = names)
}

datasetServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    reactive(
      get(input$dataset, "package:datasets") %>%
        mutate_if(~is.character(.) && length(unique(.)) <= 25, as.factor) %>%
        mutate_if(~is.numeric(.) && all(Filter(Negate(is.na), .) %% 1 == 0), as.integer)
    )
  })
}

selectVarInput <- function(id) {
  ns <- NS(id)

  selectInput(ns("var"), "Variable", choices = NULL)
}

find_vars <- function(data, filter) {
  names(data)[vapply(data, filter, logical(1))]
}

selectVarServer <- function(id, data, filter = is.numeric) {
  # stopifnot(is.reactive(data))
  # stopifnot(!is.reactive(filter))

  moduleServer(id, function(input, output, session) {
    observeEvent(data(), {
      updateSelectInput(session, "var", choices = find_vars(data(), filter))
    })

    # reactive(data()[[input$var]])
    list(
      name = reactive(input$var),
      value = reactive(data()[[input$var]])
    )
  })
}

datasetApp <- function(filter = is.numeric) {
  ui <- fluidPage(
    sidebarLayout(
      sidebarPanel(
        datasetInput("data", is.data.frame),
        selectVarInput("var"),
        histogramBins("hist")
      ),
      mainPanel(
        # tableOutput("data")
        verbatimTextOutput("summary"),
        verbatimTextOutput("out"),
        histogramOutput("hist")
      )
    )
  )

  server <- function(input, output, session) {
    data <- datasetServer("data")

    # x <- selectVarServer("var", data, filter = filter)
    # use {zeallot} and %<-%
    # return to a list var seems better
    c(name, value) %<-% selectVarServer("var", data)

    # output$data <- renderTable(head(data()))
    output$summary <- renderPrint(str(data()))
    output$out <- renderPrint(value())
    histogramServer("hist", value, name)
  }

  shinyApp(ui, server)
}

# shinyApp
datasetApp()


