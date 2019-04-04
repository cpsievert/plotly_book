library(rvest)
library(dplyr)

src <- html("https://en.wikipedia.org/wiki/List_of_African_countries_by_population")
afr_pop <- src %>%
  html_node("table") %>%
  html_table() %>%
  select(1:2) %>%
  setNames(c("name", "pop")) %>%
  mutate(pop = readr::parse_number(pop))

usethis::use_data(afr_pop, overwrite = TRUE)
