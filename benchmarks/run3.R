examples <- Sys.glob("*.html")
cmds <- paste("node run.js", examples)
time <- lapply(cmds, system, intern = TRUE)
time <- as.numeric(time)
metadata <- strsplit(tools::file_path_sans_ext(examples), "-")

d <- data.frame(
  type = sapply(metadata, "[[", 1),
  n = as.numeric(sapply(metadata, "[[", 2)),
  time = time
)

p <- plot_ly(d) %>%
  add_lines(x = ~n, y = ~time, color = ~type) %>%
  layout(
    dragmode = "x",
    yaxis = list(type = "log", title = "Time in seconds"),
    xaxis = list(type = "log")
  )

withr::with_dir("results", {
  orca(p, "run.svg")
  htmlwidgets::saveWidget(p, "run.html")
})