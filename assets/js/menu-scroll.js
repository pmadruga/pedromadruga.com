// Menu scroll position persistence
(function() {
  const menu = document.getElementById('menu');
  if (menu) {
    const stored = localStorage.getItem("menu-scroll-position");
    if (stored) {
      menu.scrollLeft = parseInt(stored, 10);
    }
    menu.onscroll = function() {
      localStorage.setItem("menu-scroll-position", menu.scrollLeft);
    };
  }
})();
