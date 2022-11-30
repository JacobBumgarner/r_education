library(shiny)
library(shinydashboard)
library(shinydashboardPlus)

# Data processing
pm_data <- read.csv("data/pm_symptoms.csv")
pm_system_counts <- as.data.frame(table(pm_data$System))

dcssc_data <- read.csv("data/dcssc_symptoms.csv")
dcssc_system_counts <- as.data.frame(table(dcssc_data$System))

# Set processing
unique
symptom_intersection <- intersect(pm_data$Symptom, dcssc_data$Symptom)

library(eulerr)

fit <- euler(c("A" = 1, "B" = 2, "A&B" = 2))
plot(fit, labels = c("1", "2", "3"))
