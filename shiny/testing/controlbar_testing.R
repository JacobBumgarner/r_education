library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
library(shinyWidgets)
library(shinyjs)
library(colourpicker)

ui <- dashboardPage(
    skin = "black",
    dashboardHeader(
        title = "test"
    ),
    sidebar = dashboardSidebar(
        sidebarMenu(
            id = "sidebar",
            menuItem(
                "1",
                tabName = "1"
            ),
            menuItem(
                "2",
                tabName = "2"
            )
        )
    ),
    body = dashboardBody(
        box(width = 12, status = "danger"),
        useShinyjs()
    ),
    controlbar = dashboardControlbar(
        id = "controlbar",
        conditionalPanel(
            condition = "input.sidebar == 1",
            br(),
            fluidRow(
                column(12,
                    offset = 0,
                    box(
                        title = "Graph Options",
                        icon = icon("chart-simple"),
                        status = "black",
                        colourInput("women_color", "Select Women Color:", "#c90076"),
                        colourInput("men_color", "Select Men Color:", "#2986cc"),
                        headerBorder = FALSE,
                        solidHeader = TRUE,
                        width = 12,
                        background = "gray"
                    )
                ),
            )
        )
    ),
)

check_controlbar_toggle <- function(bar_status) {
    if (bar_status == TRUE) {
        # addClass(selector = "body", class = "control-sidebar-open")
        addClass(selector = "body > div.wrapper > aside#controlbar", class = "control-sidebar-open")
    }
}

server <- function(input, output, session) {
    observeEvent(input$sidebar, {
        if (input$sidebar %in% c("2")) {
            # removeClass(selector = "body", class = "control-sidebar-open")
            removeClass(selector = "body > div.wrapper > aside#controlbar", class = "control-sidebar-open")
            hide(selector = "body > div.wrapper > header > nav > div:nth-child(4) > ul")
        } else {
            shinyjs::show(selector = "body > div.wrapper > header > nav > div:nth-child(4) > ul")
            check_controlbar_toggle(input$controlbar)
        }
    })
}

shinyApp(ui, server)

### Figure out how to collapse controlbar based on tab selection
