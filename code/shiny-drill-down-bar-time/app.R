library(shiny)
library(plotly)
library(dplyr)
library(purrr)

load("sales.rda")
categories <- unique(sales$category)

ui <- fluidPage(
  plotlyOutput("bar"),
  uiOutput("back"),
  plotlyOutput("time")
)

server <- function(input, output, session) {

  current_category <- reactiveVal()

  # report sales by category, unless a category is chosen
  sales_data <- reactive({
    if (!length(current_category())) {
      return(count(sales, category, wt = sales))
    }
    sales %>%
      filter(category %in% current_category()) %>%
      count(sub_category, wt = sales)
  })

  # the pie chart
  output$bar <- renderPlotly({
    d <- setNames(sales_data(), c("x", "y"))

    plot_ly(d) %>%
      add_bars(x = ~x, y = ~y, color = ~x) %>%
      layout(title = current_category() %||% "Total Sales")
  })

  # same as sales_data
  sales_data_time <- reactive({
    if (!length(current_category())) {
      return(count(sales, category, order_date, wt = sales))
    }
    sales %>%
      filter(category %in% current_category()) %>%
      count(sub_category, order_date, wt = sales)
  })

  output$time <- renderPlotly({
    d <- setNames(sales_data_time(), c("color", "x", "y"))
    plot_ly(d) %>%
      add_lines(x = ~x, y = ~y, color = ~color)
  })

  # update the current category if the clicked value matches a category
  observe({
    cd <- event_data("plotly_click")$x
    if (isTRUE(cd %in% categories)) current_category(cd)
  })

  # populate back button if category is chosen
  output$back <- renderUI({
    if (length(current_category()))
      actionButton("clear", "Back", icon("chevron-left"))
  })

  # clear the chosen category on back button press
  observeEvent(input$clear, current_category(NULL))
}

shinyApp(ui, server)