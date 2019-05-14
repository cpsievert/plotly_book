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

    p <- plot_ly(d, x   = ~x, y = ~y) %>%
      add_markers(color = I("black"), alpha = 0.05) %>%
      toWebGL() %>%
      layout(showlegend = FALSE)

    if (!input$smooth) return(p)

    add_lines(p, data = dpred, x = ~x, y = ~yhat, color = I("red"))
  })

}

shinyApp(ui, server)