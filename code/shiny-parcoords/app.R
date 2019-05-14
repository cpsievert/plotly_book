library(shiny)
library(plotly)

ui <- fluidPage(
  plotlyOutput("parcoords"),
  verbatimTextOutput("info")
)

server <- function(input, output, session) {

  d <- dplyr::select_if(iris, is.numeric)

  output$parcoords <- renderPlotly({

    dims <- Map(function(x, y) {
      list(
        values = x,
        range = range(x, na.rm = TRUE),
        label = y
      )
    }, d, names(d), USE.NAMES = FALSE)

    plot_ly() %>%
      add_trace(
        type = "parcoords",
        dimensions = dims
      ) %>%
      event_register("plotly_restyle")
  })

  output$info <- renderPrint({
    d <- event_data("plotly_restyle")
    if (is.null(d)) "Brush along a dimension" else d
  })

}

shinyApp(ui, server)