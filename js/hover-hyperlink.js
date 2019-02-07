function(el) {
  el.on('plotly_hover', function(d) {
    var url = d.points[0].customdata;
    var ann = {
      text: "<a href='" + url + "'>" + url + "</a>",
      x: 0,
      y: 0,
      xref: "paper",
      yref: "paper",
      yshift: -40,
      showarrow: false
    };
    Plotly.relayout(el.id, {annotations: [ann]});
 });
}
