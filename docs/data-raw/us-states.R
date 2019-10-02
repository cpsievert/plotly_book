# Generate a GeoJSON file of US state boundaries

library(rnaturalearth)
library(sf)
library(geojsonio)

usa <- ne_states(iso_a2 = "US", returnclass = "sf")
usa <- usa %>%
  select(name) %>%
  filter(!name %in% c("Alaska", "Hawaii"))

st_write(
  usa,
  dsn = "data-raw/us-states.json",
  driver = "GeoJSON",
  delete_dsn = TRUE
)

# plotly.js is very insistent on there being a top-level
# id that is linked to the location attribute
# https://github.com/plotly/plotly.js/issues/4154#issuecomment-526198848
# TODO: make this easier!!
us <- geojson_read("data-raw/us-states.json")
us$features <- Map(function(x, y) {
  x$id <- y; x
}, us$features, as.character(usa$name))
jsonlite::write_json(us, path = "data-raw/us-states.json", auto_unbox = TRUE)
# gistr::gist_create("data-raw/us-states.json")
