#
# This is a Shiny web application. You can run the application by clicking
# the 'Run App' button above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(dplyr)
library(shiny)
library(gapminder)
library(plotly)
library(DT)
library(gt)
library(kableExtra)


ui <- fluidPage(
    tags$h1("R Table Showcase"),
    selectInput(
        inputId = "selectCountry",
        label = "Select country:",
        choices = unique(gapminder$country),
        selected = "Poland"
    ),

    # GT table
    tags$h2("GT Table"),
    gt_output(outputId = "gtTable"),

    # Kable Extra table
    tags$h2("Kable Extra Table"),
    tableOutput(outputId = "kableExtraTable"),

    # DT table
    tags$h2("DT Table"),
    DTOutput(outputId = "dtTable"),

    # Plotly table
    tags$h2("Plotly Table"),
    plotlyOutput(outputId = "plotlyTable")
)

server <- function(input, output) {
    data <- reactive(
        gapminder %>%
            filter(country == input$selectCountry) %>%
            select(year, lifeExp)
    )

    # GT table
    output$gtTable <- render_gt({
        data() %>%
            gt() %>%
            tab_header(title = paste("Life expectancy in", input$selectCountry, "over time")) %>%
            cols_label(year = "Year", lifeExp = "Life expectancy (years)") %>%
            tab_source_note(source_note = "Source: GapMinder dataset") %>%
            tab_style(
                style = list(cell_fill(color = "#F4F4F4")),
                locations = cells_body(columns = year)
            )
    })

    # Kable Extra table
    output$kableExtraTable <- reactive({
        data() %>%
            kbl(caption = paste("Life expectancy in", input$selectCountry, "over time")) %>%
            kable_material() %>%
            kable_styling(bootstrap_options = c("striped", "hover"))
    })

    # DT table
    output$dtTable <- renderDT({
        datatable(
            data = data(),
            colnames = c("Year", "Life expectancy (years)"),
            caption = paste("Table shows life expectancy in", input$selectCountry, "over time"),
            filter = "top"
        )
    })

    # Plotly table
    output$plotlyTable <- renderPlotly({
        plot_ly(
            type = "table",
            columnwidth = c(100, 100),
            columnorder = c(0, 1),
            header = list(
                values = c("Year", "Life expectancy (years)"),
                align = c("center", "center"),
                line = list(width = 1, color = "#000000"),
                fill = list(color = c("#0099f9", "#0099F9")),
                font = list(size = 14, color = "#FFFFFF"),
                height = 40
            ),
            cells = list(
                values = rbind(data()$year, data()$lifeExp),
                align = c("center", "center"),
                line = list(width = 1, color = "#000000"),
                font = list(size = 12, color = "#000000")
            )
        )
    })
}

shinyApp(ui, server)

