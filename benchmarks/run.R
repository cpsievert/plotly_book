library(plotly)

build <- function(p, name) {
  htmltools::save_html(p, file = paste0(name, ".html"))
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

n_ <- c(1e1, 1e2, 1e3, 1e4, 1e5, 1e6)

results <- Map(function(f, name) {
  lapply(n_, function(n) {
    build(f(n), paste0(name, "-", n))
  })[-1]
}, plot_functions, names(plot_functions))
