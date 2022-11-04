library(shiny)



page1_mainpanel <- fluidPage(
  tabsetPanel(
    tabPanel("Import data",
      fileInput("file", "Data", buttonLabel = "Upload..."),
      textInput("delim", "Delimiter (leave blank to guess)", ""),
      numericInput("skip", "Rows to skip", 0, min = 0),
      numericInput("rows", "Rows to preview", 10, min = 1)
    ),
    tabPanel("Sidebar",
      sidebarLayout(
       sidebarPanel(
         numericInput("m", "Number of samples:", 2, min = 1, max = 100)
       ),
       mainPanel(
         plotOutput("hist")
       )
      )
    ),
    tabPanel("Navlist",
      navlistPanel(
        id = "tabset",
        "Heading 1",
        tabPanel("panel 1", "Panel one contents"),
        "Heading 2",
        tabPanel("panel 2", "Panel two contents"),
        tabPanel("panel 3", "Panel three contents"),
      ),
    ),
  )
)

page1 <- sidebarLayout(
  sidebarPanel(
    titlePanel("Hello, Shiny"),
  ),
  mainPanel(page1_mainpanel),
  position = "right",
)

ui <- navbarPage(
  theme = bslib::bs_theme(bootswatch = "sketchy"),
  "Main page",
  tabPanel("panel 1", page1),
  tabPanel("panel 2", "two"),
  tabPanel("panel 3", "three"),
  navbarMenu(
    "more",
    tabPanel("panel 4a", "four-a"),
    tabPanel("panel 4a", "four-a"),
    tabPanel("panel 4a", "four-a"),
  ),
)

server <- function(input, output, session) {
  thematic::thematic_shiny()
  output$hist <- renderPlot({
    means <- replicate(1e4, mean(runif(input$m)))
    hist(means, breaks = 20)
  }, res = 96)
}

shinyApp(ui, server)
