library(plotly)
library(shiny)

ui <- fluidPage(
  fluidRow(
    column(6, plotlyOutput("p1")),
    column(6, plotlyOutput("p2")),
  )
)

server <- function(input, output, session) {

  plot_it <- function(x, y) {
    d <- event_data("plotly_selected")
    p <- plot_ly(mtcars, x = x, y = y) %>%
      add_markers(key = row.names(mtcars), color = I("black"))
    if (!is.null(d)) {
      p <- add_markers(p, data = d, x = ~x, y = ~y, color = I("red"))
    }
    layout(p, dragmode = "lasso", showlegend = FALSE)
  }

  output$p1 <- renderPlotly({
    plot_it(~wt, ~mpg)
  })

  output$p2 <- renderPlotly({
    plot_it(~wt, ~disp)
  })

}

shinyApp(ui, server, options = list(display.mode = "showcase"))
