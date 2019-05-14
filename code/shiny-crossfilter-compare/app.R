library(plotly)
library(nycflights13)
library(colourpicker)
library(ggstat)

shiny::shinyAppDir(
  system.file(package = "plotly", "examples", "shiny", "crossfilter_compare")
)