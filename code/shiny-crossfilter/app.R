library(plotly)
library(nycflights13)
library(ggstat)

shiny::shinyAppDir(
  system.file(package = "plotly", "examples", "shiny", "crossfilter")
)