// Start of the tx-annotate.js file
function(el) {
  el.on("plotly_hover", function(d) {
    var pt = d.points[0];
    var cd = pt.customdata;
    var num = cd[1] ? cd[1] : "No";
    var ann = {
      text: num + " homes were sold in "+cd[0]+", TX in this month",
      x: 0.5,
      y: 1,
      xref: "paper",
      yref: "paper",
      xanchor: "middle",
      showarrow: false
    };
    var circle = {
      type: "circle",
      xanchor: pt.x,
      yanchor: pt.y,
      x0: -6,
      x1: 6,
      y0: -6,
      y1: 6,
      xsizemode: "pixel",
      ysizemode: "pixel"
    };
    Plotly.relayout(el.id, {annotations: [ann], shapes: [circle]});
  });
}
