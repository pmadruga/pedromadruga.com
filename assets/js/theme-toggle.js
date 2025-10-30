// Theme toggle functionality
(function() {
  const themeToggle = document.getElementById("theme-toggle");
  if (themeToggle) {
    themeToggle.addEventListener("click", () => {
      if (document.body.className.includes("dark")) {
        document.body.classList.remove('dark');
        localStorage.setItem("pref-theme", 'light');
      } else {
        document.body.classList.add('dark');
        localStorage.setItem("pref-theme", 'dark');
      }
    });
  }
})();
