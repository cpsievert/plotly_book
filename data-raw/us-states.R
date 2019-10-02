library(albersusa)
library(geojsonio)

sf::st_write(
  usa_sf("laea"),
  dsn = "data-raw/us-states.json",
  driver = "GeoJSON",
  delete_dsn = TRUE
)

us <- geojson_read("data-raw/us-states.json")
us$features <- Map(function(x, y) {
  x$id <- y; x
}, us$features, usa_sf("laea")$name)
geojson_write(us, file = "us-states.json")



# Make sure there is a top-level id for each feature
# as plotly.js will want us to link the location attribute
# to this id. TODO: make this easier for others!
# https://github.com/plotly/plotly.js/issues/4154#issuecomment-526198848
us_list <- usa_sf("laea") %>%
  sf_geojson() %>%
  geojson_list()



geojson_write(us_list, file = "data-raw/us-states.json")
