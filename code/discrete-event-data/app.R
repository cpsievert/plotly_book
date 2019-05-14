library(shiny)
library(dplyr)
library(plotly)

ui <- fluidPage(
  plotlyOutput("bars"),
  verbatimTextOutput("click")
)

classes <- sort(unique(mpg$class))

server <- function(input, output, session) {

  output$bars <- renderPlotly({
    ggplot(mpg, aes(class, fill = drv, customdata = drv)) + geom_bar()
  })

  output$click <- renderPrint({
    d <- event_data("plotly_click")
    if (is.null(d)) return("Click a bar")
    mpg %>%
      filter(drv %in% d$customdata) %>%
      filter(class %in% classes[d$x])
  })

}

shinyApp(ui, server)