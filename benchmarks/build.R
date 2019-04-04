library(plotly)
library(bench)
library(dplyr)

build <- function(p) {
  tmp <- tempfile(fileext = ".html")
  withr::with_dir(dirname(tmp), {
    htmltools::save_html(p, file = basename(tmp))
  })
}

n <- c(1e3, 1e4, 1e5, 1e6)

scatter <- press(
  n = n, {
    mark(build(plot_ly(x = rnorm(n), y = rnorm(n), alpha = 0.1)))
  }
)

lines <- press(
  n = n, {
    mark(build(plot_ly(x = rnorm(n), y = rnorm(n)) %>% add_lines()))
  }
)

results <- bind_rows(
  mutate(scatter, type = "points"),
  mutate(lines, type = "lines"),
)

saveRDS(results, "build.rds")

results %>%
  plot_ly(
    x = ~n, y = ~median, color = ~type,
    mode = "markers+lines", error_x = list(
      type = "data",
      symmetric = F,
      array = ~max - median,
      arrayminus = ~median - min
    )
  ) %>%
  layout(
    yaxis = list(type = "log", title = "Time in seconds"),
    xaxis = list(type = "log")
  )


orca(p, "build.svg")
htmlwidgets::saveWidget(p, "build.html")