// This file is automatically compiled by Webpack, along with any other files
// present in this directory. You're encouraged to place your actual application logic in
// a relevant structure within app/javascript and only use these pack files to reference
// that code so it'll be compiled.

import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"
import * as ActiveStorage from "@rails/activestorage"
import "channels"
import flatpickr from "flatpickr";
import "flatpickr/dist/flatpickr.css"; // Import the Flatpickr CSS

Rails.start()
Turbolinks.start()
ActiveStorage.start()


document.addEventListener('DOMContentLoaded', function() {
  console.log("DOM is loaded!");
  flatpickr('.flatpickr-input', {
    enableTime: true,
    dateFormat: 'Y-m-d H:i',
    // You can add more Flatpickr configuration options here
  });
});

