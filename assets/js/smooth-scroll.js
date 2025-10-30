// Smooth scroll for anchor links
(function() {
  document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener("click", function(e) {
      e.preventDefault();
      const id = this.getAttribute("href").substr(1);
      const target = document.querySelector(`[id='${decodeURIComponent(id)}']`);

      if (target) {
        if (!window.matchMedia('(prefers-reduced-motion: reduce)').matches) {
          target.scrollIntoView({ behavior: "smooth" });
        } else {
          target.scrollIntoView();
        }

        if (id === "top") {
          history.replaceState(null, null, " ");
        } else {
          history.pushState(null, null, `#${id}`);
        }
      }
    });
  });
})();
