library(shiny)

library(plotly)
library(leaflet)

# load ui
source("source/introduction.R")
source("source/epidemiology.R")
source("source/eu_centers.R")

# UI
sidebar_width <- 275
ui <- dashboardPage(
    # Main page
    dashboardHeader(
        title = "Case Report: dcSSc & PM", titleWidth = sidebar_width
    ),

    # Sidebar
    dashboardSidebar(
        width = sidebar_width,
        sidebarMenu(
            menuItem(
                "Introduction",
                tabName = "introduction", icon = icon("home")
            ),
            menuItem(
                "Epidemiology",
                tabName = "epidemiology", icon = icon("chart-simple")
            ),
            menuItem(
                "EU Expert Networks",
                tabName = "expert_networks", icon = icon("location-dot")
            )
        )
    ),

    # Body
    dashboardBody(
        tabItems(
            introduction_tab,
            epidemiology_tab,
            expert_networks_tab
        )
    ),
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
