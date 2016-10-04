library(plotly)
library(shiny)

ui <- fluidPage(
  fluidRow(
    column(9, plotlyOutput("p1"))
  ),
  fluidRow(
    column(9, plotlyOutput("p2"))
  )
)

server <- function(input, output, session) {

  nms <- row.names(mtcars)

  output$p1 <- renderPlotly({
    d <- event_data("plotly_selected")
    p <- plot_ly(mtcars, x = ~wt, y = ~mpg) %>%
      add_markers(key = ~nms, color = I("black"))
    if (!is.null(d)) {
      m <- mtcars[nms %in% d[["key"]], ]
      p <- add_markers(p, data = m, color = I("red"))
    }
    layout(p, dragmode = "lasso", showlegend = FALSE)
  })

  output$p2 <- renderPlotly({
    d <- event_data("plotly_selected")
    p <- plot_ly(mtcars, x = ~wt, y = ~disp, key = ~nms) %>%
      add_markers(key = ~nms, color = I("black"))
    if (!is.null(d)) {
      m <- mtcars[nms %in% d[["key"]], ]
      p <- add_markers(p, data = m, color = I("red"))
    }
    layout(p, dragmode = "lasso", showlegend = FALSE)
  })

}

shinyApp(ui, server, options = list(display.mode = "showcase"))