library(rvest)
src <- html("https://www.science.co.il/language/Locale-codes.php")
locale_table <- html_table(src)[[1]] %>%
  tibble::as_tibble()

usethis::use_data(locale_table)