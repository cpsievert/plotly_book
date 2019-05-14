library(shiny)
library(plotly)

# cache computation of the correlation matrix
correlation <- round(cor(mtcars), 3)

ui <- fluidPage(
  plotlyOutput("heat"),
  plotlyOutput("scatterplot")
)

server <- function(input, output, session) {

  output$heat <- renderPlotly({
    plot_ly(source = "heat_plot") %>%
      add_heatmap(
        x = names(mtcars),
        y = names(mtcars),
        z = correlation
      )
  })

  output$scatterplot <- renderPlotly({
    # if there is no click data, render nothing!
    clickData <- event_data("plotly_click", source = "heat_plot")
    if (is.null(clickData)) return(NULL)

    # Obtain the clicked x/y variables and fit linear model to those 2 vars
    vars <- c(clickData[["x"]], clickData[["y"]])
    d <- setNames(mtcars[vars], c("x", "y"))
    yhat <- fitted(lm(y ~ x, data = d))

    # scatterplot with fitted line
    plot_ly(d, x = ~x) %>%
      add_markers(y = ~y) %>%
      add_lines(y = ~yhat) %>%
      layout(
        xaxis = list(title = clickData[["x"]]),
        yaxis = list(title = clickData[["y"]]),
        showlegend = FALSE
      )
  })

}

shinyApp(ui, server)