// Start of the tx-mean-sales.js file
function(el) {
  el.on("plotly_hover", function(d) {
    var pt = d.points[0];
    var city = pt.customdata[0];

    // get the sales for the clicked city
    var cityInfo = pt.data.customdata.filter(function(cd) {
      return cd ? cd[0] == city : false;
    });
    var sales = cityInfo.map(function(cd) { return cd[1] });

    // yes, plotly bundles d3 which you can access via Plotly.d3
    var avgsales = Math.round(Plotly.d3.mean(sales));

    // Display the mean sales for the clicked city
    var ann = {
      text: "Mean monthly sales for " + city + " is " + avgsales,
      x: 0.5,
      y: 1,
      xref: "paper",
      yref: "paper",
      xanchor: "middle",
      showarrow: false
    };
    Plotly.relayout(el.id, {annotations: [ann]});
  });
}
