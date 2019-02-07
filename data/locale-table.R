library(rvest)
src <- html("https://www.science.co.il/language/Locale-codes.php")
html_table(src)[[1]] %>%
  tibble::as_tibble() %>%
  readr::write_csv("data/locale-table.csv")