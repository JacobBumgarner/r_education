library(shiny)
library(shinyjs)

library(DT)
library(plotly)
library(leaflet)

source("source/introduction.R")
source("source/epidemiology.R")
source("source/eu_centers.R")
source("source/symptoms.R")
source("source/controlbar_updates.R")

# UI
sidebar_width <- 275
ui <- dashboardPage(
    skin = "black",
    # options = list(sidebarExpandOnHover = TRUE),

    # Header
    dashboardHeader(
        title = icon("suitcase-medical"),
        titleWidth = sidebar_width,
        controlbarIcon = div(icon("gears"), "Graph Options")
    ),

    # Sidebar
    dashboardSidebar(
        width = sidebar_width,
        collapsed = TRUE, 
        sidebarMenu(
            id = "sidebar",
            menuItem(
                "Introduction",
                tabName = "introduction", icon = icon("home")
            ),
            menuItem(
                "Disease Symptoms",
                tabName = "symptoms", icon = icon("head-side-virus")
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
        useShinyjs(),
        tabItems(
            introduction_tab,
            epidemiology_tab,
            symptoms_tab,
            expert_networks_tab
        ),
        tags$script(HTML("$('body').addClass('fixed');")) # Fix the nav/bars
    ),

    # Controlbar
    dashboardControlbar(
        id = "controlbar",
        conditionalPanel(
            condition = "input.sidebar == 'symptoms'",
            symptoms_options,
        ),
        conditionalPanel(
            condition = "input.sidebar == 'epidemiology'",
            epidemiology_options
        ),
        conditionalPanel(
            condition = "input.sidebar == 'expert_networks'",
            expert_networks_options
        ),
        overlay = TRUE,
        collapsed = TRUE
    )
)

# Server
server <- function(input, output, session) {
    ## Controlbar updates
    observeEvent(input$sidebar, {
        toggle_controlbar(input)
    })

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

    ## Symptom Page Reactivity
    # Frequency Heatmap
    output$symptom_frequency_heatmap <- renderPlotly({
        render_symptom_frequency_heatmap(input$frequency_heatmap_cmap)
    })

    output$system_frequency_heatmap <- renderPlotly({
        render_system_frequency_heatmap(input$frequency_heatmap_cmap)
    })

    output$symptom_frequency_bar <- renderPlotly({
        render_symptom_frequency_bar_plot(
            input$diseases_symptoms,
            input$dcssc_freq_color,
            input$pm_freq_color
        )
    })

    output$system_frequency_pie <- renderPlotly({
        render_system_pie_plot(input$system_pie_colormap)
    })

    # Tables
    output$dcssc_symptoms_table <- renderDataTable({dcssc_server_table})
    output$pm_symptoms_table <- renderDataTable({pm_server_table})

    ## Expert Center Page Reactivity
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
        ) %>% config(displaylogo = FALSE)
    )
}

shinyApp(ui, server)
