txsmall %>%
  group_by(city) %>%
  do(
    p = highlight_key(., ~year, group = "txhousing-trellis") %>%
      plot_ly(showlegend = FALSE) %>%
      group_by(year) %>%
      add_lines(
        x = ~month, y = ~median, text = ~year,
        hoverinfo = "text"
      ) %>%
      add_annotations(
        text = ~unique(city),
        x = 0.5, y = 1,
        xref = "paper", yref = "paper",
        xanchor = "center", yanchor = "bottom",
        showarrow = FALSE
      )
  ) %>%
  subplot(
    nrows = 2, margin = 0.05,
    shareY = TRUE, shareX = TRUE, titleY = FALSE
  )
