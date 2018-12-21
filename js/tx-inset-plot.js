function(el) {
  el.on("plotly_hover", function(d) {
    var pt = d.points[0];
    var city = pt.customdata[0];

    // get the sales for the clicked city
    var cityInfo = pt.data.customdata.filter(function(cd) {
      return cd ? cd[0] == city : false;
    });
    var sales = cityInfo.map(function(cd) { return cd[1] });

    // Collect all the trace types in this plot
    var types = el.data.map(function(trace) { return trace.type; });
    // Find the array index of the histogram trace
    var histogramIndex = types.indexOf("histogram");

    // If the histogram trace already exists, just supply new x values
    if (histogramIndex > -1) {

      Plotly.restyle(el.id, "x", [sales], histogramIndex);

    } else {

      // create the histogram
      var trace = {
        x: sales,
        type: "histogram",
        marker: {color: "#1f77b4"},
        xaxis: "x2",
        yaxis: "y2"
      };
      Plotly.addTraces(el.id, trace);

      // place it on "inset" axes
      var x = {
        domain: [0.05, 0.4],
        anchor: "y2"
      };
      var y = {
        domain: [0.6, 0.9],
        anchor: "x2"
      };
      Plotly.relayout(el.id, {xaxis2: x, yaxis2: y});

    }

    // Add a title for the histogram
    var ann = {
      text: "Monthly house sales in " + city + ", TX",
      x: 2003,
      y: 300000,
      xanchor: "middle",
      showarrow: false
    };
    Plotly.relayout(el.id, {annotations: [ann]});

    // Add a vertical line reflecting sales for the hovered point
    var line = {
      type: "line",
      x0: pt.customdata[1],
      x1: pt.customdata[1],
      y0: 0.6,
      y1: 0.9,
      xref: "x2",
      yref: "paper",
      line: {color: "black"}
    };
    Plotly.relayout(el.id, {'shapes[1]': line});
  });
}