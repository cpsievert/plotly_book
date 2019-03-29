plot_ly() %>% 
  add_text(
    x = rep(2, 2), 
    y = 1:2, 
    size = I(15),
    text = c(
      "Glyphs: Ѳ, （╯°□°）╯ ┻━┻",
      "Unicode: \U00AE \U00B6 \U00BF"
    ),
    hovertext = c(
      "glyphs",
      "unicode"
    ),
    textposition = "left center",
    hoverinfo = "text"
  )
