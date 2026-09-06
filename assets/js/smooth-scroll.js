// Smooth scroll for anchor links
(function() {
  document.querySelectorAll('a[href^="#"]').forEach(anchor => {
    anchor.addEventListener("click", function(e) {
      e.preventDefault();
      const id = this.getAttribute("href").slice(1);
      const target = document.querySelector(`[id='${decodeURIComponent(id)}']`);

      if (target) {
        if (!window.matchMedia('(prefers-reduced-motion: reduce)').matches) {
          target.scrollIntoView({ behavior: "smooth" });
        } else {
          target.scrollIntoView();
        }

        // preventDefault also cancels the browser moving sequential focus
        // to the target, so a keyboard user activating a TOC link would stay
        // focused in the TOC; restore that.
        if (!target.hasAttribute("tabindex")) {
          target.setAttribute("tabindex", "-1");
        }
        target.focus({ preventScroll: true });

        if (id === "top") {
          history.replaceState(null, null, " ");
        } else {
          history.pushState(null, null, `#${id}`);
        }
      }
    });
  });
})();
