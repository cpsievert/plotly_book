library(shiny)
library(plotly)

ui <- fluidPage(
  plotlyOutput("p"),
  verbatimTextOutput("event")
)

server <- function(input, output, session) {

  output$p <- renderPlotly({
    plot_ly() %>%
      layout(
        xaxis = list(range = c(-10, 10)),
        yaxis = list(range = c(-10, 10)),
        shapes = list(
          type = "circle",
          fillcolor = "gray",
          line = list(color = "gray"),
          x0 = -10, x1 = 10,
          y0 = -10, y1 = 10,
          xsizemode = "pixel",
          ysizemode = "pixel",
          xanchor = 0, yanchor = 0
        )
      ) %>%
      config(edits = list(shapePosition = TRUE))
  })

  output$event <- renderPrint({
    event_data("plotly_relayout")
  })

}

shinyApp(ui, server)