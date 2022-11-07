linkedScatterUI <- function(id) {
  ns <- NS(id)
  tagList(
    column(6, plotOutput(ns("plot1"), brush = ns("brush"))),
    column(6, plotOutput(ns("plot2"), brush = ns("brush")))
  )
}

scatterPlot <- function(data, cols) {
  ggplot(data, aes_string(x = cols[1], y = cols[2])) +
    geom_point(aes(color = selected_)) +
    scale_color_manual(values = c("black", "#66D65C"), guide = "none")
}

linkedScatterServer <- function(id, data, left, right) {
  moduleServer(
    id,
    function(input, output, session) {
      dataWithSelection <- reactive({
        brushedPoints(data(), input$brush, allRows = TRUE)
      })

      output$plot1 <- renderPlot({
        scatterPlot(dataWithSelection(), left())
      })

      output$plot2 <- renderPlot({
        scatterPlot(dataWithSelection(), right())
      })

      return(dataWithSelection)
    }
  )
}
