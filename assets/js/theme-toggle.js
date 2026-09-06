// Theme toggle functionality
(function() {
  const themeToggle = document.getElementById("theme-toggle");
  if (themeToggle) {
    const html = document.documentElement;
    // expose the toggle's state to assistive tech (the label alone says
    // nothing about which theme is active)
    const syncState = () => {
      themeToggle.setAttribute("aria-pressed", String(html.dataset.theme === "dark"));
    };
    syncState();
    themeToggle.addEventListener("click", () => {
      if (html.dataset.theme === "dark") {
        html.dataset.theme = "light";
        localStorage.setItem("pref-theme", "light");
      } else {
        html.dataset.theme = "dark";
        localStorage.setItem("pref-theme", "dark");
      }
      syncState();
    });
  }
})();
