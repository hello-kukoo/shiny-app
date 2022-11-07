library(shiny)
library(ggplot2)

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      csvFileUI("datafile", "User data (.csv format)")
    ),
    mainPanel(
      dataTableOutput("table"),
      linkedScatterUI("plot")
    )
  )
)

server <- function(input, output, session) {
  datafile <- csvFileServer("datafile", stringsAsFactors = FALSE)

  output$table <- renderDataTable(
    datafile(), options = list(pageLength = 10)
  )

  df <- linkedScatterServer("plot", datafile,
                            left = reactive(c("age", "stage")),
                            right = reactive(c("gender", "stage")))
}

shinyApp(ui, server)
