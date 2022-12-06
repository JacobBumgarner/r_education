library(shiny)
library(shinydashboard)
library(shinydashboardPlus)

library(DT)
library(plotly)
library(eulerr)
library(colorspace)

# Load the data
source("data/symptoms_data_processing.R")


## Page Layout
# Title
title <- fluidRow(box(
    title = tags$h2(
        "Disease Symptoms Overview",
        align = "center"
    ),
    width = 12,
    height = "50%",
    tags$h4(
        HTML(
            "
        Here we can visualize the frequency of the associated symptoms for each disease.
        As we can see, there isn't much overlap in the specific symptoms of each disease,
        the but affected systems are quite similar.
        <br><br>
        The symptom data were extracted from
        <a target='_blank' href='https://hpo.jax.org/app'>https://hpo.jax.org/app/</a>.
        The extraction routine can be
        <a target='_blank' href='https://github.com/JacobBumgarner/r_education/blob/main/shiny/ssc_pm_case_study/disease_scraper.ipynb'>
        found here</a>.
        "
        ),
        align = "center"
    )
))

# Heatmaps
render_symptom_frequency_heatmap <- function(colormap) {
    colors <- sequential_hcl(4, colormap, rev = TRUE)
    colors[1] <- "#ede6e1"
    colorscale <- data.frame(
        z = sort(c(c(0:3), c(1:4))) / 4,
        col = as.character(c(rbind(colors, colors)))
    )
    colorscale$col <- as.character(colorscale$col)

    plot_ly(
        x = colnames(symptom_frequencies[1:2]),
        y = rownames(symptom_frequencies),
        z = as.matrix(symptom_frequencies[1:2]),
        ygap = 1,
        xgap = 1,
        zmin = 0,
        zmax = 4,
        colorscale = colorscale,
        colorbar = list(
            title = "<b>Symptom Frequency",
            tickmode = "array",
            tickvals = c(colSums(rbind(c(0:3), c(1:4)), 2) / 2),
            ticktext = c("Not Present", "Occasional", "Frequent", "Very Frequent")
        ),
        type = "heatmap",
        text = symptom_hovertext,
        hoverinfo = "text"
    ) %>%
        colorbar(
            y = 0.75,
            length = 0.5,
            thickness = 20,
            tickfont = list(size = 10),
            titlefont = list(size = 12)
        ) %>%
        layout(
            xaxis = list(tickfont = list(size = 12)),
            yaxis = list(tickfont = list(size = 10))
        )
}


symptom_frequency_heatmap_box <- box(
    title = "Symptom Frequency Heatmap",
    status = "black",
    width = 12,
    collapsible = TRUE,
    plotlyOutput("symptom_frequency_heatmap", height = "600px")
)


render_system_frequency_heatmap <- function(colormap) {
    max_count <- max(system_frequencies) + 1
    colors <- sequential_hcl(max_count, colormap, rev = TRUE)
    colors[1] <- "#ede6e1"
    colorscale <- data.frame(
        z = sort(c(c(0:(max_count - 1)), c(1:max_count))) / max_count,
        col = as.character(c(rbind(colors, colors)))
    )
    colorscale$col <- as.character(colorscale$col)

    plot_ly(
        x = colnames(system_frequencies),
        y = rownames(system_frequencies),
        z = as.matrix(system_frequencies),
        type = "heatmap",
        xgap = 1,
        ygap = 1,
        zmin = 0,
        zmax = max_count,
        colorscale = colorscale,
        colorbar = list(
            title = "<b>Symptoms per System</b>",
            tickmode = "array",
            tickvals = c(colSums(rbind(c(0:(max_count - 1)), c(1:max_count)), 2) / 2),
            ticktext = c(0:8)
        ),
        text = system_hovertext,
        hoverinfo = "text"
    ) %>%
        colorbar(
            y = 0.75,
            length = 0.5,
            thickness = 20,
            tickfont = list(size = 10),
            titlefont = list(size = 12)
        ) %>%
        layout(
            xaxis = list(tickfont = list(size = 12))
            # yaxis = list(tickfont = list(size = 6))
        )
}

system_frequency_heatmap_box <- box(
    title = "Affected Systems Heatmap",
    status = "black",
    width = 12,
    collapsible = TRUE,
    plotlyOutput("system_frequency_heatmap", height = "600px")
)


# Frequency Bars
render_symptom_frequency_bar_plot <- function(diseases, dcssc_color, pm_color) {
    if (!length(diseases)) {
        return()
    }

    # Set up the colors
    colors <- if (length(diseases) == 2) {
        c(dcssc_color, pm_color)
    } else if (length(diseases)) {
        if (diseases[1] == "dcSSc") {
            c(dcssc_color)
        } else {
            c(pm_color)
        }
    }

    # Create the empty plot
    plot <- plot_ly()

    for (i in seq_along(diseases)) {
        plot <- plot %>% add_trace(
            x = rownames(total_frequencies),
            y = total_frequencies[, diseases[i]],
            marker = list(color = colors[i]),
            hoverinfo = "text",
            text = paste0(
                "Disease: ", diseases[i], "<br>",
                "Symptoms: ", total_frequencies[, diseases[i]]
            ),
            name = diseases[i],
            type = "bar"
        )
    }

    # Plot boiler plate
    plot <- plot %>% layout(
        xaxis = list(
            categoryarray = rownames(total_frequencies), categoryorder = "array"
        ),
        showlegend = TRUE
    )

    plot
}

symptom_frequency_bar_box <- box(
    title = "Symptom Frequency Counts",
    status = "black",
    width = 12,
    collapsible = TRUE,
    plotlyOutput("symptom_frequency_bar")
)


generate_system_pie <- function(plot, data, labels, title, column, colormap) {
    colors <- qualitative_hcl(nrow(data), palette = colormap)
    plot <- plot %>% add_pie(
        data,
        labels = data$System,
        values = data$Symptoms,
        marker = list(
            colors = colors,
            line = list(color = "#FFFFFF", width = 1)
        ),
        textposition = "inside",
        text = labels,
        textinfo = "label",
        hoverinfo = "text",
        insidetextfont = list(color = "#FFFFFF"),
        type = "pie",
        showlegend = FALSE,
        title = list(text = title, font = list(size = 16)),
        name = title,
        domain = list(row = 0, column = (column - 1))
    )
    plot
}

render_system_pie_plot <- function(colormap = NULL) {
    system_freqs <- list(dcssc_system_freqs, pm_system_freqs)
    labels <- list(dcssc_pie_labels, pm_pie_labels)
    titles <- list("<b>dcSSc</b>", "<b>PM</b>")

    plot <- plot_ly()
    for (i in 1:2) {
        plot <- generate_system_pie(
            plot,
            system_freqs[[i]],
            labels[[i]],
            titles[[i]],
            i,
            colormap
        )
    }

    plot <- plot %>% layout(
        grid = list(rows = 1, columns = 2)
    )
    plot
}


system_frequency_pie_plot <- box(
    title = "Affected Systems Distribution",
    status = "black",
    width = 12,
    collapsible = TRUE,
    plotlyOutput("system_frequency_pie")
)

# Data Tables
dcssc_table <- box(
    title = "dcSSc Data",
    status = "black",
    icon = icon("book"),
    collapsible = TRUE,
    width = 12,
    dataTableOutput("dcssc_symptoms_table")
)
dcssc_server_table <- datatable(
    dcssc_data,
    selection = "none",
    extensions = "Buttons",
    options = list(
        "dom" = "lBfrtip",
        buttons = list(
            "copy",
            list(
                extend = "collection",
                buttons = c("csv", "excel", "pdf"),
                text = "Download"
            )
        ),
        lengthMenu = list(c(5, 10, 20), c(5, 10, 20))
    )
)

pm_table <- box(
    title = "PM Data",
    status = "black",
    icon = icon("book"),
    width = 12,
    collapsible = TRUE,
    dataTableOutput("pm_symptoms_table")
)
pm_server_table <- datatable(
    pm_data,
    selection = "none",
    extensions = "Buttons",
    options = list(
        "dom" = "lBfrtip",
        buttons = list(
            "copy",
            list(
                extend = "collection",
                buttons = c("csv", "excel", "pdf"),
                text = "Download"
            )
        ),
        lengthMenu = list(c(5, 10, 20), c(5, 10, 20))
    )
)


# Tabs
# Symptoms options
heatmap_colormap <- selectInput(
    "frequency_heatmap_cmap", "Select Colormap for Frequency Heatmap:",
    choices = c("Reds", "OrRd", "YlOrRd", "Oranges", "Heat", "Heat 2", "Blues", "PuRd")
)

disease_checkbox <- checkboxGroupInput(
    "diseases_symptoms",
    "Select Diseases to Visualize:",
    choices = c(
        "dcSSc",
        "PM"
    ),
    selected = c("dcSSc", "PM")
)

dcssc_color_box <- colourInput(
    "dcssc_freq_color", "Select dcSSc Color",
    value = "#F0C678"
)

pm_color_box <- colourInput(
    "pm_freq_color", "Select PM Color",
    value = "#F0A8E4"
)

system_frequency_colormap <- selectInput(
    "system_pie_colormap", "Select Colormap for Affected Systems: ",
    choices = c(
        "Pastel 1", "Dark 2", "Dark 3", "Set 2", "Set 3", "Warm", "Cold",
        "Harmonic", "Dynamic"
    ),
    selected = "Warm"
)

symptoms_options <- fluidRow(
    column(12,
        offset = 0,
        box(
            title = "Graph Options",
            icon = icon("chart-simple"),
            status = "black",
            headerBorder = FALSE,
            solidHeader = TRUE,
            collapsible = TRUE,
            width = 12,
            background = "gray",
            heatmap_colormap,
            disease_checkbox,
            system_frequency_colormap,
            dcssc_color_box,
            pm_color_box
        )
    ),
)

# Main tab
symptoms_tab <- tabItem(
    tabName = "symptoms",
    title,
    fluidRow(
        column(
            6,
            symptom_frequency_heatmap_box,
            symptom_frequency_bar_box,
            dcssc_table,
            style = "padding: 0px;"
        ),
        column(
            6,
            system_frequency_heatmap_box,
            system_frequency_pie_plot,
            pm_table,
            style = "padding: 0px;"
        )
    )
)
