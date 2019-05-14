library(shiny)
library(plotly)
library(dplyr)
library(nycflights13)

ui <- fluidPage(
  plotlyOutput("arr_time"),
  plotlyOutput("dep_time")
)

server <- function(input, output, session) {

  output$arr_time <- renderPlotly({
    p <- plot_ly(flights, x = ~arr_time, source = "arr_time")

    brush <- event_data("plotly_brushing", source = "dep_time")
    if (is.null(brush)) return(p)

    p %>%
      filter(between(dep_time, brush$x[1], brush$x[2])) %>%
      add_histogram()
  })

  output$dep_time <- renderPlotly({
    p <- plot_ly(flights, x = ~dep_time, source = "dep_time")

    brush <- event_data("plotly_brushing", source = "arr_time")
    if (is.null(brush)) return(p)

    p %>%
      filter(between(arr_time, brush$x[1], brush$x[2])) %>%
      add_histogram()
  })

}

shinyApp(ui, server)