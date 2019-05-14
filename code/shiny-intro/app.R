library(shiny)
library(plotly)

ui <- fluidPage(
  selectizeInput(
    inputId = "cities",
    label = "Select a city",
    choices = unique(txhousing$city),
    selected = "Abilene",
    multiple = TRUE
  ),
  plotlyOutput(outputId = "p")
)

server <- function(input, output, ...) {
  output$p <- renderPlotly({
    plot_ly(txhousing, x = ~date, y = ~median) %>%
      filter(city %in% input$cities) %>%
      group_by(city) %>%
      add_lines()
  })
}

shinyApp(ui, server)