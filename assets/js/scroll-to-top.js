// Scroll to top button visibility
(function() {
  const topButton = document.getElementById("top-link");
  if (topButton) {
    window.onscroll = function() {
      if (document.body.scrollTop > 800 || document.documentElement.scrollTop > 800) {
        topButton.style.visibility = "visible";
        topButton.style.opacity = "1";
      } else {
        topButton.style.visibility = "hidden";
        topButton.style.opacity = "0";
      }
    };
  }
})();
