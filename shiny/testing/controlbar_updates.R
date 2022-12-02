library(shiny)
library(shinyjs)

# Check whether to show the controlbar or not when it is enabled
check_controlbar_toggle <- function(bar_status) {
    if (bar_status == TRUE) {
        # addClass(selector = "body > div.wrapper > aside#controlbar", class = "control-sidebar-open")
        addClass(selector = "body", class = "control-sidebar-open")
    }
}

# Hide the controlbar based on specific tab selections
toggle_controlbar <- function(input) {
    if (input$sidebar %in% c("introduction")) {
        # removeClass(selector = "body > div.wrapper > aside#controlbar", class = "control-sidebar-open")
        removeClass(selector = "body", class = "control-sidebar-open")
        hide(
            selector = "
            body > div.wrapper > header > nav > div:nth-child(4) > ul
            "
        )
    } else {
        show(
            selector = "
            body > div.wrapper > header > nav > div:nth-child(4) > ul
            "
        )
        check_controlbar_toggle(input$controlbar)
    }
}
