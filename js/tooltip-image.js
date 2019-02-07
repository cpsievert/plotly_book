// inspired, in part, by https://stackoverflow.com/a/48174836/1583084
function(el) {
  var tooltip = Plotly.d3.select('#' + el.id + ' .svg-container')
    .append("div")
    .attr("class", "my-custom-tooltip");

  el.on('plotly_hover', function(d) {
    var pt = d.points[0];
    // Choose a location (on the data scale) to place the image
    // Here I'm picking the top-left corner of the graph
    var x = pt.xaxis.range[0];
    var y = pt.yaxis.range[1];
    // Transform the data scale to the pixel scale
    var xPixel = pt.xaxis.l2p(x) + pt.xaxis._offset;
    var yPixel = pt.yaxis.l2p(y) + pt.yaxis._offset;
    // Insert the base64 encoded image
    var img = "<img src='" +  pt.customdata + "' width=100>";
    tooltip.html(img)
      .style("position", "absolute")
      .style("left", xPixel + "px")
      .style("top", yPixel + "px");
    // Fade in the image
    tooltip.transition()
      .duration(300)
      .style("opacity", 1);
  });

  el.on('plotly_unhover', function(d) {
    // Fade out the image
    tooltip.transition()
      .duration(500)
      .style("opacity", 0);
  });
}
