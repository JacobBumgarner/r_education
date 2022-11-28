library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
source("app_source/ui.R", local = TRUE)
source("app_source/server.R", local = TRUE)

shinyApp(ui, server)
