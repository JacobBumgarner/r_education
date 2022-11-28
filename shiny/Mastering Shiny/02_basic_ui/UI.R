library(shiny)

ui <- fluidPage(
    # free text
    textInput("name", "What is your name?", placeholder = "Your name"),
    
    # numeric inputs
    numericInput("age", "What is your age?", value = 0, min = 0, max = 120),

    # date inputs
    dateInput("date", "Please enter today's date:"),

    # Dropdown and radio
    selectInput("state", "Please select your state of residence:", state.name),

    # File uploads
    fileInput("upload", "Upload an image of your ID."),

    # Action buttons
    actionButton("continue", "Continue")

)

server <- function(input, output, session) {
    
}

shinyApp(ui, server)
