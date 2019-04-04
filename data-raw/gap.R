library(rvest)
library(dplyr)
library(gapminder)

src <- html("https://simple.wikipedia.org/wiki/List_of_countries_by_area")
tabs <- html_table(src)
countryArea <- tabs[[3]][, -1]
names(countryArea) <- c("country", "area")
countryArea$area <- as.numeric(gsub(",", "", countryArea$area))
countryArea$country <- sub("^Israel", "Israel", countryArea$country)
countryArea$country <- sub(
  "Democratic Republic of the Congo", "Congo, Dem. Rep.", countryArea$country, fixed = T
)
countryArea$country <- sub(
  "Republic of the Congo", "Congo, Rep.", countryArea$country, fixed = T
)
countryArea$country <- sub(
  "Myanmar (Burma)", "Myanmar", countryArea$country, fixed = T
)
countryArea$country <- sub(
  "North Korea", "Korea, Dem. Rep.", countryArea$country, fixed = T
)
countryArea$country <- sub(
  "South Korea", "Korea, Rep.", countryArea$country, fixed = T
)
countryArea$country <- sub(
  "United States of America", "United States", countryArea$country, fixed = T
)

gap <- gapminder %>%
  dplyr::left_join(countryArea, by = "country") %>%
  transform(popDen = pop / area) %>%
  transform(country = forcats::fct_reorder(country, popDen)) %>%
  as_tibble()

usethis::use_data(gap, overwrite = TRUE)