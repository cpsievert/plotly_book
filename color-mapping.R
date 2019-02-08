library(plotly)
library(purrr)

p1 <- plotly_empty() %>%
  add_annotations(
    text = "<b>Data space</b>",
    x = 0,
    xshift = 20,
    y = 0.5,
    xref = "paper",
    yref = "paper",
    xanchor = "left",
    showarrow = FALSE
  ) %>%
  add_annotations(
    text = "<b>Visual space</b>",
    x = 1,
    y = 0.5,
    xref = "paper",
    yref = "paper",
    xanchor = "right",
    showarrow = FALSE
  )

lvls <- levels(diamonds$clarity)
lvls <- factor(lvls, lvls)
cols <- scales::col_factor("Accent", domain = NULL)(lvls)

n <- length(lvls)
grid <- c(0, cumsum(rep(1/n, n)))
y <- map2_dbl(grid[-length(grid)], grid[-1], ~(.x+.y)/2)

rects <- map(
  cols,
  ~list(
    type = "rect",
    fillcolor = .x,
    x0 = 0.75,
    x1 = 0.85,
    xref = "paper",
    yref = "paper",
    line = list(width = 1)
  )
)

for (i in seq_len(n)) {
  rects[[i]]$y0 <- grid[i]
  rects[[i]]$y1 <- grid[i+1]
}

p2 <- plotly_empty() %>%
  add_annotations(
    text = paste(lvls, "  "),
    x = 0.70,
    y = y,
    xref = "paper",
    yref = "paper",
    xanchor = "right",
    yanchor = "middle",
    ax = -100,
    ay = 0
  ) %>%
  layout(
    shapes = rects
  )

p3 <- plotly_empty() %>%
  add_annotations(
    text = "<b>Diamond<br>clarity</b>",
    x = 0,
    xshift = 20,
    y = 0,
    xref = "paper",
    yref = "paper",
    xanchor = "left",
    yanchor = "bottom",
    showarrow = FALSE
  ) %>%
  add_annotations(
    text = "<b>RColorBrewer<br>Accent palette</b>",
    x = 1,
    y = 0,
    xref = "paper",
    yref = "paper",
    xanchor = "right",
    yanchor = "bottom",
    showarrow = FALSE
  )


p <- subplot(p1, p2, p3, nrows = 3, heights = c(0.1, 0.8, 0.1)) %>%
  layout(
    height = 450,
    width = 250,
    margin = list(l = 0, b = 0, t = 0, r = 0)
  )

withr::with_dir("images", orca(p, "color-mapping.svg"))
withr::with_dir("images", orca(p, "color-mapping.pdf"))