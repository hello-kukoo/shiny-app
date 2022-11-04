library(shiny)
library(purrr)


sliderInput01 <- function(id, label = id, min = 0, max = 1) {
  sliderInput(id, label, min, max, value = 0.5, step = 0.1)
}

usWeekDateInput <- function(inputId, ...) {
  dateInput(inputId, ..., format = "dd M, yy", daysofweekdisabled = c(0, 6))
}

vars01 <- c("alpha", "beta", "gamma", "delta")
sliders01 <- map(vars01, sliderInput01)

vars02 <- tibble::tribble(
  ~ id, ~ label, ~ min, ~ max,
  "alpha", "Alpha", 0, 1,
  "beta", "Beta", 0, 10,
  "gamma", "Gamma", -1, 1,
  "delta", "Delta", 0, 1,
)
sliders02 <- pmap(vars02, sliderInput01)

ui <- fluidPage(
  sliders01,
  usWeekDateInput("date", label="Date"),
  sliders02,
)

server <- function(input, output, session) {

}

shinyApp(ui, server)
