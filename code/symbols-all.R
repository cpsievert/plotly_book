vals <- schema(F)$traces$scatter$attributes$marker$symbol$values
vals <- grep("-", vals, value = T)
plot_ly() %>%
  add_markers(
    x = rep(1:12, each = 11, length.out = length(vals)),
    y = rep(1:11, times = 12, length.out = length(vals)),
    text = vals,
    hoverinfo = "text",
    marker = list(
      symbol = vals,
      size = 30,
      line = list(
        color = "black",
        width = 2
      )
    )
  )
