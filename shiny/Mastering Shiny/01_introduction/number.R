library(shiny)

ui <- fluidPage(
    sliderInput("x", label = "IF x is:", min = 1, max = 50, value = 30),
    sliderInput("y", label = "IF x is:", min = 1, max = 50, value = 30),
    "then x times y is",
    textOutput("product")

)

server <- function(input, output, session) {
    x <- reactive({input$x})
    y <- reactive({input$y})

    output$product <- renderText({
        x() * y()
    })
}

shinyApp(ui, server)

