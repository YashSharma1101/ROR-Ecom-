// app/assets/javascripts/calculate_gst.js

document.addEventListener('DOMContentLoaded', function() {
  document.getElementById('calculate-gst-button').addEventListener('click', function() {
    var total_price = parseFloat(document.getElementById('order_total_price').value);
    var gst_percentage = 18;
    var total_gst = (total_price * gst_percentage) / 100;
    document.getElementById('order_total_gst').value = total_gst.toFixed(2);
  });
});
