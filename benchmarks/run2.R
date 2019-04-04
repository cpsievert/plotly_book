library(plotly)
library(chromote)
#library(future)
#plan(multisession)

tmp <- tempfile(fileext = ".html")
servr::httd(dirname(tmp))

build <- function(p) {
  file <- basename(tmp)
  withr::with_dir(dirname(tmp), {
    htmltools::save_html(p, file = file)
  })
  file
}

# TODO: do this asyncronously in parallel
run <- function(file) {
  b <- chromote::Chromote$new()
  # gives weird results for webgl
  time <- system.time({
    b$Page$navigate(paste0("http://127.0.0.1:4321/", file))
    b$Page$loadEventFired()
  })[["elapsed"]]

  b$close()

  time
  #b$Performance$enable()
  #metrics1 <- b$Performance$getMetrics()$metrics
  #b$Page$navigate(paste0("file://", file))
  #b$Page$loadEventFired(function(x) {
  #  browser()
  #  start <- metrics1[[match("Timestamp", sapply(metrics1, "[[", "name"))]]$value
  #  print(x$timestamp - start)
  #})
}

plot_functions <- list(
  scatter = function(n) {
    plot_ly(x = rnorm(n), y = rnorm(n), alpha = 0.1)
  },
  scattergl = function(n) {
    plot_ly(x = rnorm(n), y = rnorm(n), alpha = 0.1, type = "scattergl")
  },
  pointcloud = function(n) {
    plot_ly(x = rnorm(n), y = rnorm(n), type = "pointcloud")
  },
  scatter_lines = function(n) {
    plot_ly(x = rnorm(n), y = rnorm(n)) %>% add_lines()
  },
  scattergl_lines = function(n) {
    plot_ly(x = rnorm(n), y = rnorm(n)) %>% add_lines() %>% toWebGL()
  }
)

n_ <- c(1e1, 1e2, 1e3, 1e4, 1e5)

results <- lapply(plot_functions, function(f) {
  lapply(n_, function(n) run(build(f(n))))[-1]
})


saveRDS(results, "run-results.rds")
beepr::beep(3)

p <- plot_ly() %>%
  layout(
    dragmode = "x",
    yaxis = list(type = "log", title = "Time in seconds"),
    xaxis = list(type = "log")
  )

for (i in seq_along(results)) {
  y <- as.numeric(results[[i]])
  nm <- names(results)[i]
  p <- add_lines(p, name = nm, x = c(1e2, 1e3, 1e4, 1e5), y = y)
}

orca(p, "run.svg")
htmlwidgets::saveWidget(p, "run.html")

# TODO:
#  (1) use profiler or something to measure responsiveness of hover/zoom?
#  (2) use async to run the benchmarks in parallel
