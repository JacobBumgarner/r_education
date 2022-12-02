library(plotly)
library(colorspace)

# Frequencies
dcssc_data <- read.csv("/Users/jacobbumgarner/Desktop/r_education/shiny/ssc_pm_case_study/data/dcssc_symptoms.csv")
pm_data <- read.csv("/Users/jacobbumgarner/Desktop/r_education/shiny/ssc_pm_case_study/data/pm_symptoms.csv")

get_frequencies <- function(data) {
    frequencies <- as.data.frame(select(data, "Symptom", "Frequency"))
    frequencies$id <- 0
    frequencies$id[frequencies$Frequency == "Occasional"] <- 1
    frequencies$id[frequencies$Frequency == "Frequent"] <- 2
    frequencies$id[frequencies$Frequency == "Very frequent"] <- 3
    frequencies
}

pm_freqs <- get_frequencies(pm_data)
dcssc_freqs <- get_frequencies(dcssc_data)

add_na_column <- function(main_frame, second_frame) {
    main_NA <- setdiff(second_frame$Symptom, main_frame$Symptom)

    addon_df <- data.frame(Symptom = main_NA, Frequency = "NA", id = 0)

    main_frame <- rbind(main_frame, addon_df)
    main_frame <- main_frame[order(main_frame$Symptom), ]
    main_frame
}

# Add NA frequencies
final_dcssc_freqs <- add_na_column(dcssc_freqs, pm_freqs)
final_pm_freqs <- add_na_column(pm_freqs, dcssc_freqs)

# Symptom frequencies table
symptom_frequencies <- data.frame(
    dcSSc = final_dcssc_freqs$id,
    PM = final_pm_freqs$id
)
rownames(symptom_frequencies) <- final_dcssc_freqs$Symptom
symptom_frequencies <- symptom_frequencies[
    order(symptom_frequencies[, 2], symptom_frequencies[, 1]),
]

# Make the plot
colors <- sequential_hcl(4, "OrRd", rev = TRUE)
colors[1] <- "#ede6e1"
colorscale <- data.frame(
    z = sort(c(c(0:3), c(1:4))) / 4,
    col = as.character(c(rbind(colors, colors)))
)
colorscale$col <- as.character(colorscale$col)

plot_ly(
    x = colnames(symptom_frequencies),
    y = rownames(symptom_frequencies),
    z = as.matrix(symptom_frequencies),
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
    type = "heatmap"
)