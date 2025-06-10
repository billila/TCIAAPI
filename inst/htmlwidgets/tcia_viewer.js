HTMLWidgets.widget({

  name: 'tcia_viewer',
  type: 'output',

  factory: function(el, width, height) {
    var iframe = null; // Keep a reference to the iframe

    return {
      renderValue: function(x) {
        // x contains data from R: x.url

        // Clear any previous content from the element
        el.innerHTML = "";

        // Create the iframe
        iframe = document.createElement('iframe');
        iframe.id = el.id + "-iframe"; // Optional: give the iframe a unique ID
        iframe.src = x.url;

        // Style the iframe to take up all the space of the widget container
        // 'el'
        iframe.style.width = "100%";
        iframe.style.height = "100%";
        // Remove default iframe border
        iframe.style.border = "none";
        // For older browser compatibility
        iframe.setAttribute('frameborder', '0');
        // Allow fullscreen if caMicroscope supports it
        iframe.setAttribute('allowfullscreen', 'true');

        // Append the iframe to the HTML widget element
        el.appendChild(iframe);
      },

      resize: function(newWidth, newHeight) {
        // The iframe with style width/height "100%" should resize automatically
        // when its container 'el' (the widget div) is resized by htmlwidgets.
        // Thus, explicit iframe resizing code is usually not needed here.
        // If you were to need it:
        // if (iframe) {
        //   iframe.style.width = newWidth + "px"; // Not standard with 100% CSS
        //   iframe.style.height = newHeight + "px";
        // }
      }
    };
  }
});
