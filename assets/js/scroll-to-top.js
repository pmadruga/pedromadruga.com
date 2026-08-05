// Scroll to top button visibility
(function() {
  const topButton = document.getElementById("top-link");
  if (topButton) {
    window.onscroll = function() {
      const scrollThreshold = window.innerHeight;
      if (document.body.scrollTop > scrollThreshold || document.documentElement.scrollTop > scrollThreshold) {
        topButton.classList.remove("hidden");
      } else {
        topButton.classList.add("hidden");
      }
    };
  }
})();
