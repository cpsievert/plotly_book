library(shiny)
library(plotly)
library(dplyr)

load("sales.rda")

ui <- fluidPage(
  plotlyOutput("category", height = 200),
  plotlyOutput("sub_category", height = 200),
  plotlyOutput("sales", height = 300),
  dataTableOutput("datatable")
)

# avoid repeating this code
axis_titles <- . %>%
  layout(
    xaxis = list(title = ""),
    yaxis = list(title = "Sales")
  )

server <- function(input, output, session) {

  # for maintaining the state of drill-down variables
  category <- reactiveVal()
  sub_category <- reactiveVal()
  order_date <- reactiveVal()

  # when clicking on a category,
  observeEvent(event_data("plotly_click", source = "category"), {
    category(event_data("plotly_click", source = "category")$x)
    sub_category(NULL)
    order_date(NULL)
  })

  observeEvent(event_data("plotly_click", source = "sub_category"), {
    sub_category(event_data("plotly_click", source = "sub_category")$x)
    order_date(NULL)
  })

  observeEvent(event_data("plotly_click", source = "order_date"), {
    order_date(event_data("plotly_click", source = "order_date")$x)
  })

  output$category <- renderPlotly({
    sales %>%
      count(category, wt = sales) %>%
      plot_ly(x = ~category, y = ~n, source = "category") %>%
      axis_titles() %>%
      layout(title = "Sales by category")
  })

  output$sub_category <- renderPlotly({
    if (is.null(category())) return(NULL)

    sales %>%
      filter(category %in% category()) %>%
      count(sub_category, wt = sales) %>%
      plot_ly(x = ~sub_category, y = ~n, source = "sub_category") %>%
      axis_titles() %>%
      layout(title = category())
  })

  output$sales <- renderPlotly({
    if (is.null(sub_category())) return(NULL)

    sales %>%
      filter(sub_category %in% sub_category()) %>%
      count(order_date, wt = sales) %>%
      plot_ly(x = ~order_date, y = ~n, source = "order_date") %>%
      add_lines() %>%
      axis_titles() %>%
      layout(title = paste(sub_category(), "sales over time"))
  })

  output$datatable <- renderDataTable({
    if (is.null(order_date())) return(NULL)

    sales %>%
      filter(
        sub_category %in% sub_category(),
        as.Date(order_date) %in% as.Date(order_date())
      )
  })

}

shinyApp(ui, server)