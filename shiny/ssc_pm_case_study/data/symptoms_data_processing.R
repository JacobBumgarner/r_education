library(dplyr)

## Extract the data for the page
# Frequencies
dcssc_data <- read.csv("/Users/jacobbumgarner/Desktop/r_education/shiny/ssc_pm_case_study/data/dcssc_symptoms.csv")
pm_data <- read.csv("/Users/jacobbumgarner/Desktop/r_education/shiny/ssc_pm_case_study/data/pm_symptoms.csv")

get_symptom_frequencies <- function(data) {
    frequencies <- as.data.frame(select(data, "Symptom", "Frequency"))
    frequencies$id <- 0
    frequencies$id[frequencies$Frequency == "Occasional"] <- 1
    frequencies$id[frequencies$Frequency == "Frequent"] <- 2
    frequencies$id[frequencies$Frequency == "Very frequent"] <- 3
    frequencies
}

pm_freqs <- get_symptom_frequencies(pm_data)
dcssc_freqs <- get_symptom_frequencies(dcssc_data)

add_na_column <- function(main_frame, second_frame) {
    main_NA <- setdiff(second_frame$Symptom, main_frame$Symptom)

    addon_df <- data.frame(Symptom = main_NA, Frequency = "Not Present", id = 0)

    main_frame <- rbind(main_frame, addon_df)
    main_frame <- main_frame[order(as.character(main_frame$Symptom)), ]
    main_frame
}

# Add NA frequencies
final_dcssc_freqs <- add_na_column(dcssc_freqs, pm_freqs)
final_pm_freqs <- add_na_column(pm_freqs, dcssc_freqs)

# Symptom frequencies table
# HEATMAP
symptom_frequencies <- data.frame(
    dcSSc = final_dcssc_freqs$id,
    PM = final_pm_freqs$id,
    dcSSc_Freq = final_dcssc_freqs$Frequency,
    PM_Freq = final_pm_freqs$Frequency
)
rownames(symptom_frequencies) <- final_dcssc_freqs$Symptom
symptom_frequencies <- symptom_frequencies[
    order(symptom_frequencies[, 1], symptom_frequencies[, 2]),
]
symptom_frequencies

paste0(
    "Disease: <br>",
    "Frequency: ", symptom_frequencies$dcSSc_Freq
)

generate_symptom_hover_text <- function(disease, frequencies) {
    paste0(
        "Disease: ", disease,
        "<br>",
        "Symptom: ", rownames(frequencies),
        "<br>",
        "<b>Frequency: ", frequencies[, 1]
    )
}

symptom_hovertext <- cbind(
    generate_symptom_hover_text("dcSSc", symptom_frequencies["dcSSc_Freq"]),
    generate_symptom_hover_text("PM", symptom_frequencies["PM_Freq"])
)
symptom_hovertext

# FREQUENCY BAR
total_frequencies <- data.frame(
    cbind(
        dcSSc = table(symptom_frequencies$dcSSc_Freq, exclude = "Not Present"),
        PM = table(symptom_frequencies$PM_Freq, exclude = "Not Present")
    )
)
total_frequencies <- total_frequencies[
    c("Occasional", "Frequent", "Very frequent"),
]


# Affected Systems
add_system_na_column <- function(main_frame, second_frame) {
    main_NA <- setdiff(second_frame$System, main_frame$System)

    addon_df <- data.frame(System = main_NA, Symptoms = 0)
    main_frame <- rbind(main_frame, addon_df)
    main_frame <- main_frame[order(as.character(main_frame$System)), ]
    main_frame
}

dcssc_system_freqs <- as.data.frame(table(dcssc_data$System))
colnames(dcssc_system_freqs) <- c("System", "Symptoms")
dcssc_system_freqs <- dcssc_system_freqs[
    order(dcssc_system_freqs$Symptoms),
]
pm_system_freqs <- as.data.frame(table(pm_data$System))
colnames(pm_system_freqs) <- c("System", "Symptoms")
pm_system_freqs <- pm_system_freqs[
    order(pm_system_freqs$Symptoms),
]

final_dcssc_system_freqs <- add_system_na_column(
    dcssc_system_freqs, pm_system_freqs
)
final_pm_system_freqs <- add_system_na_column(
    pm_system_freqs, dcssc_system_freqs
)

system_frequencies <- data.frame(
    dcSSc = final_dcssc_system_freqs$Symptoms,
    PM = final_pm_system_freqs$Symptoms
)
rownames(system_frequencies) <- final_dcssc_system_freqs$System
system_frequencies <- system_frequencies[
    order(system_frequencies[, "dcSSc"], system_frequencies[, "PM"]),
]

generate_system_hover_text <- function(symptoms) {
    paste0(
        "Disease: ", colnames(symptoms), "<br>",
        "System: ", rownames(symptoms), "<br>",
        "Number of Symptoms: ", symptoms[, 1]
    )
}

system_hovertext <- cbind(
    generate_system_hover_text(system_frequencies["dcSSc"]),
    generate_system_hover_text(system_frequencies["PM"])
)


# Pie Processing
generate_pie_hovertext <- function(systems) {
    paste0(
        "System: ", systems$System, "<br>",
        "Symptoms: ", systems$Symptoms
    )
}
dcssc_pie_labels <- generate_pie_hovertext(dcssc_system_freqs)
pm_pie_labels <- generate_pie_hovertext(pm_system_freqs)
