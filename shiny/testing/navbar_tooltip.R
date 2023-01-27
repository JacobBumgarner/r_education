library(shiny)

  ui <- fluidPage(

    tags$style("#shiny-notification-showme_notif {position: fixed; top: 800px; left: 40px; width: 15em; opacity: 1;}"),

    tags$style("#shiny-notification-welcome_notif {position: fixed; top: 800px; right: 40px; width: 15em; opacity: 1;}"),

    actionButton("showme", "Show Notification:")

  )

  server <- function(input, output, session) {

    observe({

      showNotification(
        id = "welcome_notif",
        "Blablablablabla .... blablablabla.",
        duration = 200, 
        closeButton = TRUE,
        type = "message")

    })

    observeEvent(input$showme, {

      showNotification( 
        id = "showme_notif",
        "Hihihi", # put text in notificationdd


        
        closeButton = TRUE,
        type = "message")

   })

  }

  shinyApp(ui = ui, server = server)
