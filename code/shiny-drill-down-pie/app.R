library(shiny)
library(plotly)
library(dplyr)
library(purrr) # just for `%||%`

load("sales.rda")
categories <- unique(sales$category)

ui <- fluidPage(plotlyOutput("pie"), uiOutput("back"))

server <- function(input, output, session) {
  # for maintaining the current category (i.e. selection)
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

  # Note that pie charts don't currently attach the label/value
  # with the click data, but we can leverage `customdata` as a workaround
  output$pie <- renderPlotly({
    d <- setNames(sales_data(), c("labels", "values"))
    plot_ly(d) %>%
      add_pie(labels = ~labels, values = ~values, customdata = ~labels) %>%
      layout(title = current_category() %||% "Total Sales")
  })

  # update the current category if the clicked value matches a category
  observe({
    cd <- event_data("plotly_click")$customdata[[1]]
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