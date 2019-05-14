library(plotly)
library(shiny)

ui <- fluidPage(
  plotlyOutput("p"),
  verbatimTextOutput("info")
)

server <- function(input, output, session) {

  output$p <- renderPlotly({
    plot_ly() %>%
      layout(
        annotations = list(
          list(
            text = emo::ji("fire"),
            x = 0.5,
            y = 0.5,
            xref = "paper",
            yref = "paper",
            showarrow = FALSE
          ),
          list(
            text = "fire",
            x = 0.5,
            y = 0.5,
            xref = "paper",
            yref = "paper"
          )
        )) %>%
      config(editable = TRUE)
  })

  output$info <- renderPrint({
    event_data("plotly_relayout")
  })

}

shinyApp(ui, server)