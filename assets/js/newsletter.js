// Newsletter form: open Buttondown subscription in a popup window
(function() {
  const form = document.getElementById('bd-email');
  if (form) {
    form.addEventListener('submit', function() {
      window.open('https://buttondown.com/pedromadruga', 'popupwindow');
    });
  }
})();
