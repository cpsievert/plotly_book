library(dplyr)
cities <- c("Galveston", "Midland", "Odessa", "South Padre Island")
txsmall <- txhousing %>%
  select(city, year, month, median) %>%
  filter(city %in% cities)

txsmall %>%
  highlight_key(~year) %>% {
    ggplot(., aes(month, median, group = year)) + geom_line() +
      facet_wrap(~city, ncol = 2)
  } %>%
  ggplotly(tooltip = "year")
