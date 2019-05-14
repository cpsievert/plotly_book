library(plotly)

Sys.setenv("MAPBOX_TOKEN" = "pk.eyJ1IjoiY3BzaWV2ZXJ0IiwiYSI6ImNpdGRiOWwwMjAwMHQyem84NG5tcXg5eXIifQ.UJ2VwrJmPW8DB8H2d-wN3g")

shiny::shinyAppDir(
  system.file(package = "plotly", "examples", "shiny", "proxy_mapbox")
)