// Code block copy functionality
(function() {
  document.querySelectorAll('pre > code').forEach((codeblock) => {
    const container = codeblock.parentNode.parentNode;

    const copybutton = document.createElement('button');
    copybutton.classList.add('copy-code');
    copybutton.innerText = 'copy';

    function copyingDone() {
      copybutton.innerText = 'copied!';
      setTimeout(() => {
        copybutton.innerText = 'copy';
      }, 2000);
    }

    copybutton.addEventListener('click', () => {
      if ('clipboard' in navigator) {
        navigator.clipboard.writeText(codeblock.textContent);
        copyingDone();
        return;
      }

      const range = document.createRange();
      range.selectNodeContents(codeblock);
      const selection = window.getSelection();
      selection.removeAllRanges();
      selection.addRange(range);
      try {
        document.execCommand('copy');
        copyingDone();
      } catch (e) {
        console.error('Copy failed:', e);
      }
      selection.removeRange(range);
    });

    if (container.classList.contains("highlight")) {
      container.appendChild(copybutton);
    } else if (container.parentNode.firstChild == container) {
      // td containing LineNos
    } else if (codeblock.parentNode.parentNode.parentNode.parentNode.parentNode.nodeName == "TABLE") {
      // table containing LineNos and code
      codeblock.parentNode.parentNode.parentNode.parentNode.parentNode.appendChild(copybutton);
    } else {
      // code blocks not having highlight as parent class
      codeblock.parentNode.appendChild(copybutton);
    }
  });
})();
