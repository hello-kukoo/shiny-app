library(shiny)

animals <-
  c("dog", "cat", "mouse", "bird", "other", "I hate animals")

ui <- fluidPage(
  theme = bslib::bs_theme(bootswatch = "sketchy"),
  titlePanel("Hello Shiny!"),
  # input ------------------------------------------------------------------

  textInput("name", "What's your name?"),
  passwordInput("password", "What's your password?"),
  textAreaInput("story", "Tell me about yourself", rows = 3),

  numericInput(
    "num",
    "Number one",
    value = 10,
    min = 0,
    max = 100
  ),
  sliderInput(
    "num2",
    "Number two",
    value = 50,
    min = 0,
    max = 100
  ),
  sliderInput(
    "rng",
    "Range",
    value = c(10, 20),
    min = 0,
    max = 100
  ),

  dateInput("dob", "When were you born?", language = "zh-CN"),
  dateRangeInput(
    "holiday",
    "假期何时开始?",
    language = "zh-CN",
    separator = " 至 "
  ),

  selectInput("state", "What's your favourite state?",
              state.name, multiple = TRUE),
  radioButtons("animal", "What's your favourite animal?", animals),
  radioButtons(
    "rb",
    "Choose one:",
    choiceNames = list(icon("angry"),
                       icon("smile"),
                       icon("sad-tear")),
    choiceValues = list("angry", "happy", "sad")
  ),
  checkboxGroupInput("animals", "What animals do you like?", animals),

  checkboxInput("cleanup", "Clean up?", value = TRUE),
  checkboxInput("shutdown", "Shutdown?"),

  fileInput("upload", NULL),

  actionButton("click", "Click me!"),
  actionButton("drink", "Drink me!", icon = icon("cocktail")),

  actionButton("click", "Click me!", class = "btn-danger"),
  actionButton("drink", "Drink me!", class = "btn-lg btn-success"),

  fluidRow(actionButton("eat", "Eat me!", class = "btn-block")),

  # output ------------------------------------------------------------------

  textOutput("text"),
  verbatimTextOutput("code"),


  # output table ------------------------------------------------------------
  br(),
  h3("Fixed table"),
  tableOutput("static"),
  br(),
  h3("Dynamic table"),
  dataTableOutput("dynamic"),

  # plotting ----------------------------------------------------------------
  br(),
  h3("Plotting"),
  plotOutput("plot", width = "400px")
)

server <- function(input, output, session) {
  output$text <- renderText({
    "Hello friend!"
  })
  output$code <- renderPrint({
    summary(1:10)
  })
  output$static <- renderTable(head(mtcars))
  output$dynamic <- renderDataTable(mtcars,
                                    options = list(pageLength = 5,
                                                   searching = FALSE))
  output$plot <- renderPlot(plot(1:5), res = 96)
}

shinyApp(ui, server)
