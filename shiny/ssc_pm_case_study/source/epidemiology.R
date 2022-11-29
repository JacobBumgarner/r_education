library(shiny)
library(shinydashboard)
library(shinydashboardPlus)

library(plotly)
library(colourpicker)

# First load the epidemiology data
epidemiology_data <- read.csv("data/epidemiologies.csv")

dcssc_data <- epidemiology_data[epidemiology_data$disease == "dcSSc", ]
dcssc_sex_ratio <- dcssc_data$"F.M.sex.ratio"
dcssc_sex_ratio <- c(dcssc_sex_ratio * 100, (1 - dcssc_sex_ratio) * 100)

pm_data <- epidemiology_data[epidemiology_data$disease == "PM", ]
pm_sex_ratio <- pm_data$"F.M.sex.ratio"
pm_sex_ratio <- c(pm_sex_ratio * 100, (1 - pm_sex_ratio) * 100)

# Define the default pie colors & graph info
# colors <- c("#c90076", "#2986cc")
labels <- c("Women", "Men")


## Layout
# Title & text
title <- fluidRow(box(
    title = tags$h2("dcSSc & PM Epidemiology", align = "center"),
    width = 12,
    height = "50%",
    tags$h4(
    HTML(
        "
        Both of these diseases are extremely rare.
        Importantly, there is a stark sex difference in the prevalence
        of each disease, with females developing both dcSSc
        <a target='_blank' href='https://pubmed.ncbi.nlm.nih.gov/34782448/'>[1]</a>
        and PM
        <a target='_blank' href='https://www.ncbi.nlm.nih.gov/books/NBK532860/#:~:text=The%20estimated%20prevalence%20of%20polymyositis,increase%20in%20the%20detection%20rate.'>[2]</a>
        more frequently than males.
        "
    ),
    align = "center"
)
))

# Plot generation
generate_bar_plot <- function(data, colors) {
    graph <- plot_ly(
        x = labels,
        y = data,
        text = ~ paste(round(data, 2), "%", labels),
        marker = list(color = colors),
        hoverinfo = "text",
        type = "bar"
    )
    graph
}

generate_pie_chart <- function(data, colors) {
    graph <- plot_ly(
        labels = labels,
        values = data,
        textinfo = "label+percent",
        text = ~ paste(round(data, 2), "%", labels),
        hoverinfo = "text",
        marker = list(colors = colors),
        type = "pie"
    )
    graph
}

generate_epidemiology_plot <- function(graph_type, dataset, women_color, men_color) {
    # Get data
    colors <- c(women_color, men_color)
    graph_type <- tolower(graph_type)
    data <- if (tolower(dataset) == "dcssc") {
        dcssc_sex_ratio
    } else if (tolower(dataset) == "pm") {
        pm_sex_ratio
    } else {
        stop("Only 'dcSSc' and 'PM' are valid datasets for this function.")
    }

    # Generate graph
    graph <- if (graph_type == "bar plot") {
        generate_bar_plot(data, colors)
    } else if (graph_type == "pie chart") {
        generate_pie_chart(data, colors)
    } else {
        stop(
            "Only 'Bar Plot' and 'Pie Chart' are valid
            graph types for this function."
        )
    }

    # Add boiler plate
    graph <- graph %>% layout(
        title = paste0("Sex differences in ", dataset, " prevalence."),
        showlegend = FALSE
    )

    # Return the graph
    graph
}

# dcSSc Epidemiology
dcssc_prevalence_text <- infoBox(
    "Population Prevalence",
    "12.7 out of 100,000 people have dcSSc [3].",
    icon = icon("person-dress-burst", ),
    color = "purple",
    width = 12,
    fill = TRUE
)

dcssc_box <- box(
    title = "Diffuse Cutaneous Systemic Sclerosis",
    status = "danger",
    solidHeader = TRUE,
    icon = icon("chart-simple"),
    align = "center",
    dcssc_prevalence_text,
    box(plotlyOutput("dcssc_graph"), width = 12)
)

# PM Epidemiology
PM_prevalence_text <- infoBox(
    "Population Prevalence",
    "13.5 out of 100,000 people have PM [2].",
    icon = icon("person-dress-burst", ),
    color = "purple",
    width = 12,
    fill = TRUE
)

pm_box <- box(
    title = "Polymyositis",
    status = "danger",
    solidHeader = TRUE,
    icon = icon("chart-simple"),
    align = "center",
    PM_prevalence_text,
    box(plotlyOutput("pm_graph"), width = 12)
)

# Graphing options
graph_type_selection <- selectInput(
    "graph_type", "Select Graph Type:", c("Bar Plot", "Pie Chart"),
    width = 150
)

female_color_picker <- colourInput("women_color", "Select Women Color:", "#c90076")
male_color_picker <- colourInput("men_color", "Select Men Color:", "#2986cc", )

options_box <- box(
    title = "Graph Options",
    width = 12,
    status = "black",
    solidHeader = FALSE,
    icon = icon("gear"),
    align = "center",
    graph_type_selection,
    female_color_picker,
    male_color_picker
)

# References
references <- box(
    title = "References",
    icon = icon("book"),
    status = "black",
    width = 12,
    align = "left",
    tags$ol(
        tags$li("De Angelis, R., Giuggioli, D., Bajocchi, G., Dagna, L., Zanframundo, G., Foti, R., Cacciapaglia, F., Cuomo, G., Ariani, A. & Rosato, E. (2022) Sex-related differences in systemic sclerosis: a multicenter cross-sectional study from the National Registry of the Italian Society for Rheumatology. The Journal of Rheumatology. 49, 176-185."),
        tags$li("Mammen, A.L. (2016) Autoimmune myopathies. CONTINUUM: Lifelong Learning in Neurology. 22, 1852."),
        tags$li("Wibianto, A. & Santoso, I.D. (2020) Diffuse Cutaneous Systemic Scleroderma with Secondary In-fection: A Case Report. J Dermatol Res Ther. 6, 091.")
    )
)

epidemiology_tab <- tabItem(
    tabName = "epidemiology",
    title,
    fluidRow(
        dcssc_box, pm_box
    ),
    fluidRow(
        column(3, options_box, offset = 1),
        column(7, references),
    ),
)
