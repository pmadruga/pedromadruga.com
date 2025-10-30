// Menu scroll position persistence
(function() {
  const menu = document.getElementById('menu');
  if (menu) {
    menu.scrollLeft = localStorage.getItem("menu-scroll-position");
    menu.onscroll = function() {
      localStorage.setItem("menu-scroll-position", menu.scrollLeft);
    };
  }
})();
