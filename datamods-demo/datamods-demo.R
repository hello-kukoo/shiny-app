## ---------------------------
##
## Script name: datamods-demo.R
##
## Purpose of script: {datamods} demostration
##
## Author: Lin Yong
##
## Date Created: 2022-11-22
##
## Copyright (c) DataRx, 2022
## Email: yong.lin@datarx.cn
##
## ---------------------------
##
## Notes:
##
##
## ---------------------------

library(datamods)
library(shiny)

datamods::set_i18n("cn")

ui <- fluidPage(
  datamods::import_ui("datamods_ui")
)

server <- function(input, output, session) {
  datamods::import_server("datamods_ui")
}

shinyApp(ui, server)
