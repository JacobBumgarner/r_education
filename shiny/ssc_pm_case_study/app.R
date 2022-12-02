library(shiny)
library(shinyjs)

library(plotly)
library(leaflet)

source("source/introduction.R")
source("source/epidemiology.R")
source("source/eu_centers.R")
source("source/controlbar_updates.R")

# UI
sidebar_width <- 275
ui <- dashboardPage(
    skin = "black",
    # options = list(sidebarExpandOnHover = TRUE),

    # Header
    dashboardHeader(
        title = "Case Report: dcSSc & PM",
        titleWidth = sidebar_width,
        controlbarIcon = div(icon("gears"), "Graph Options")
    ),

    # Sidebar
    dashboardSidebar(
        width = sidebar_width,
        sidebarMenu(
            id = "sidebar",
            menuItem(
                "Introduction",
                tabName = "introduction", icon = icon("home")
            ),
            menuItem(
                "Epidemiology",
                tabName = "epidemiology", icon = icon("chart-simple")
            ),
            conditionalPanel(
                condition = "input.sidebar == 'epidemiology'",
                epidemiology_options
            ),
            menuItem(
                "EU Expert Networks",
                tabName = "expert_networks", icon = icon("location-dot")
            ),
            conditionalPanel(
                condition = "input.sidebar == 'expert_networks'",
                expert_networks_options
            )
        )
    ),

    # Body
    dashboardBody(
        useShinyjs(),
        tabItems(
            introduction_tab,
            epidemiology_tab,
            expert_networks_tab
        ),
        tags$script(HTML("$('body').addClass('fixed');"))  # Fix the nav/bars
    )
)

# Server
server <- function(input, output, session) {
    ## Epidemiology Page Reactivity
    output$pm_graph <- renderPlotly(
        generate_epidemiology_plot(
            input$graph_type, "PM", input$women_color, input$men_color
        )
    )
    output$dcssc_graph <- renderPlotly(
        generate_epidemiology_plot(
            input$graph_type, "dcSSc", input$women_color, input$men_color
        )
    )

    # Expert Center Page Reactivity
    # Map
    output$map <- renderLeaflet({
        isolate({
            if ("map_center" %in% names(input)) {
                mapparams <- list(
                    center = input$map_center,
                    zoom = input$map_zoom
                )
            } else {
                mapparams <- list(
                    center = list(lat = 48, lng = 9.4),
                    zoom = 4.3
                )
            }
        })
        generate_map(
            input$diseases, input$dcssc_color, input$pm_color, mapparams
        )
    })

    # Country bar plot
    output$country_plot <- renderPlotly(
        generate_country_bar_plot(
            input$diseases,
            input$dcssc_color,
            input$pm_color
        )
    )
}

shinyApp(ui, server)
