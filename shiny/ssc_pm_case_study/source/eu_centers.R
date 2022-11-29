library(shiny)
library(shinydashboard)
library(shinydashboardPlus)
library(colourpicker)

library(dplyr)
library(leaflet)

# Get the country data
df <- read.csv("data/expert_center_locations.csv")

countries <- select(df, , "country", "disease")
countries <- as.data.frame(table(countries))
country_counts <- data.frame(
    country = unique(countries$country),
    dcSSc = unname(
        select(countries[countries["disease"] == "dcSSc", ], "Freq")
    ),
    PM = unname(
        select(countries[countries["disease"] == "PM", ], "Freq")
    )
)

dcssc_coordinates <- select(
    df[df["disease"] == "dcSSc", ], "latitude", "longitude"
)
dcssc_centers <- select(
    df[df["disease"] == "dcSSc", ], "center"
)

pm_coordinates <- select(
    df[df["disease"] == "PM", ], "latitude", "longitude"
)
pm_centers <- select(
    df[df["disease"] == "PM", ], "center"
)

## Page layout
# Title
title <- fluidRow(box(
    title = tags$h2("dcSSc & PM EU Expert Treatment Centers", align = "center"),
    width = 12,
    height = "50%",
    tags$h4(
    HTML(
        "
        Below I've visualized the location of expert treatment centers for both
        dcSSc. These centers were identified using 
        <a target='_blank' href='https://www.orpha.net/consor/cgi-bin/index.php?lng=EN'>orpha.net</a>, 
        and the expert center locations were extracted
        using the Google Maps Python API 
        <a target='_blank' href='https://github.com/JacobBumgarner/r_education/blob/main/shiny/ssc_pm_case_study/location_scraper.ipynb'>(see my code here)</a>
        .
        "
    ),
    align = "center"
)
))

# Map
generate_map <- function(checked_diseases, dcssc_color, pm_color, mapparams) {
    map <- leaflet()
    map <- map %>% addProviderTiles(
        providers$Stamen.TonerLite,
        options = providerTileOptions(noWrap = TRUE)
    )
    map <- map %>%
        setView(
            lng = mapparams$center$lng,
            lat = mapparams$center$lat,
            zoom = mapparams$zoom
        )

    if ("PM" %in% checked_diseases) {
        icon <- awesomeIcons(
            icon = "hospital",
            library = "fa",
            iconColor = pm_color,
            markerColor = "lightgray"
        )
        map <- map %>%
            addAwesomeMarkers(
                data = pm_coordinates, icon = icon, label = pm_centers$center
            )
    }
    if ("dcSSc" %in% checked_diseases) {
        icon <- awesomeIcons(
            icon = "hospital",
            library = "fa",
            iconColor = dcssc_color,
            markerColor = "lightgray"
        )
        map <- map %>%
            addAwesomeMarkers(
                data = dcssc_coordinates,
                icon = icon,
                label = dcssc_centers$center
            )
    }
    map
}

# Bar Graph by Country
plot_single_disease <- function(disease, data, color) {
    plot <- plot_ly(
        country_counts,
        x = country_counts$country,
        y = data,
        marker = list(color = color),
        type = "bar",
        name = disease
    )
    plot
}

plot_both_diseases <- function(dcssc_color, pm_color) {
    plot <- plot_ly(
        country_counts,
        x = country_counts$country,
        y = country_counts$dcSSc,
        marker = list(color = dcssc_color),
        type = "bar",
        name = "dcSSc"
    )

    plot <- plot %>% add_trace(
        y = country_counts$PM,
        marker = list(color = pm_color),
        type = "bar",
        name = "PM"
    )
    plot
}

generate_country_bar_plot <- function(diseases, dcssc_color, pm_color) {
    # Double data plot
    if (length(diseases) == 2) {
        plot <- plot_both_diseases(dcssc_color, pm_color)
        disease_title <- paste0(diseases[1], " and ", diseases[2], " ")
    } else if (!is.null(diseases[1])) { # Single data plot
        if (diseases[1] == "dcSSc") {
            data <- country_counts$dcSSc
            color <- dcssc_color
        } else {
            data <- country_counts$PM
            color <- pm_color
        }

        plot <- plot_single_disease(diseases[1], data, color)
        disease_title <- paste0(diseases[1], " ")
    } else { # Empty plot
        plot <- plot_ly(type = "bar") %>%
            layout(
                xaxis = list(showticklabels = FALSE),
                yaxis = list(range = list(0, 4))
            )
        disease_title <- paste0()
    }

    # Plot boiler plate
    plot <- plot %>% layout(
        title = paste0("<b>", disease_title, "EU Expert Treatment Networks"),
        yaxis = list(dtick = 1),
        showlegend = TRUE
    )

    plot
}

bar_plot_box <- box(
    width = 12,
    status = "black",
    plotlyOutput("country_plot")
)


# Options
disease_checkbox <- checkboxGroupInput(
    "diseases",
    "Select Diseases to Visualize:",
    choices = c(
        "dcSSc",
        "PM"
    ),
    selected = c("dcSSc", "PM")
)

pm_color_box <- colourInput(
    "pm_color", "Select PM Color",
    value = "#ADEFD1"
)
dcssc_color_box <- colourInput(
    "dcssc_color", "Select dcSSc Color",
    value = "#246DB5"
)

options_box <- box(
    title = "Visualization Options",
    status = "black",
    icon = icon("gear"),
    width = 12,
    align = "left",
    disease_checkbox,
    dcssc_color_box,
    pm_color_box
)


# Tab
expert_networks_tab <- tabItem(
    tabName = "expert_networks",
    title,
    fluidRow(leafletOutput("map", width = "90%"), align = "center"),
    p(),
    fluidRow(column(7, bar_plot_box, offset = 1), column(3, options_box), align = "center"),
)