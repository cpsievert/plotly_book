library(shiny)
library(plotly)

# Generate 100,000 observations from 2 correlated random variables
d <- MASS::mvrnorm(1e6, mu = c(0, 0), Sigma = matrix(c(1, 0.5, 0.5, 1), 2, 2))
d <- setNames(as.data.frame(d), c("x", "y"))

# fit a simple linear model
m <- lm(y ~ x, data = d)

# generate y predictions over a grid of 10 x values
dpred <- data.frame(
  x = seq(min(d$x), max(d$x), length.out = 10)
)
dpred$yhat <- predict(m, newdata = dpred)

ui <- fluidPage(
  plotlyOutput("scatterplot"),
  checkboxInput("smooth", label = "Overlay fitted line?", value = FALSE)
)


server <- function(input, output, session) {

  output$scatterplot <- renderPlotly({
    plot_ly(d, x = ~x, y = ~y) %>%
      add_markers(color = I("black"), alpha = 0.05) %>%
      toWebGL()
  })

  observe({
    if (input$smooth) {
      # this is essentially the plotly.js way of doing
      # `p %>% add_lines(x = ~x, y = ~yhat) %>% toWebGL()`
      # without having to redraw the entire plot
      plotlyProxy("scatterplot", session) %>%
        plotlyProxyInvoke(
          "addTraces",
          list(
            x = dpred$x,
            y = dpred$yhat,
            type = "scattergl",
            mode = "lines",
            line = list(color = "red")
          )
        )
    } else {
      # JavaScript index starts at 0, so the '1' here really means
      # "delete the second traces (i.e., the fitted line)"
      plotlyProxy("scatterplot", session) %>%
        plotlyProxyInvoke("deleteTraces", 1)
    }
  })
}

shinyApp(ui, server)