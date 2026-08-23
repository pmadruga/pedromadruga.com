// /notes/ page (layouts/notes.html): the cards in the HTML were fetched at
// build time. This script re-fetches the feed from Bluesky's public API,
// prepends any posts that appeared since the last build (matching the
// build-time markup — keep the two in sync), then paginates the list.
// If the fetch fails, the build-time content stands as-is.
document.addEventListener('DOMContentLoaded', function () {
  var list = document.querySelector('.notes-list');
  if (!list) return;

  var API = 'https://public.api.bsky.app/xrpc/app.bsky.feed.getAuthorFeed';
  var url =
    API +
    '?actor=' +
    encodeURIComponent(list.dataset.handle) +
    '&filter=posts_no_replies&limit=100';

  function el(tag, className, text) {
    var node = document.createElement(tag);
    if (className) node.className = className;
    if (text) node.textContent = text;
    return node;
  }

  var REPOST_SVG =
    '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="17 1 21 5 17 9"></polyline><path d="M3 11V9a4 4 0 014-4h14"></path><polyline points="7 23 3 19 7 15"></polyline><path d="M21 13v2a4 4 0 01-4 4H3"></path></svg>';

  var LINK_SVG =
    '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><path d="M10 13a5 5 0 007.54.54l3-3a5 5 0 00-7.07-7.07l-1.72 1.71"></path><path d="M14 11a5 5 0 00-7.54-.54l-3 3a5 5 0 007.07 7.07l1.71-1.71"></path></svg>';

  var OPEN_SVG =
    '<svg viewBox="-25 0 400 320" fill="none" stroke="currentColor" stroke-width="30"><path d="M180 141.964C163.699 110.262 119.308 51.1817 78.0347 22.044C38.4971 -5.86834 23.414 -1.03207 13.526 3.43594C2.08093 8.60755 0 26.1785 0 36.5164C0 46.8542 5.66748 121.272 9.36416 133.694C21.5786 174.738 65.0603 188.607 105.104 184.156C107.151 183.852 109.227 183.572 111.329 183.312C109.267 183.642 107.19 183.924 105.104 184.156C46.4204 192.847 -5.69621 214.233 62.6582 290.33C137.848 368.18 165.705 273.637 180 225.702C194.295 273.637 210.76 364.771 295.995 290.33C360 225.702 313.58 192.85 254.896 184.158C252.81 183.926 250.733 183.645 248.671 183.315C250.773 183.574 252.849 183.855 254.896 184.158C294.94 188.61 338.421 174.74 350.636 133.697C354.333 121.275 360 46.8568 360 36.519C360 26.1811 357.919 8.61012 346.474 3.43851C336.586 -1.02949 321.503 -5.86576 281.965 22.0466C240.692 51.1843 196.301 110.262 180 141.964Z"></path></svg>';

  var PLAY_SVG =
    '<svg viewBox="0 0 24 24" fill="currentColor"><path d="M8 5v14l11-7z"></path></svg>';

  function buildCard(item) {
    var post = item.post;
    var card = el('article', 'note-card');
    card.dataset.atid = post.uri;
    var rkey = post.uri.split('/').pop();
    var link = 'https://bsky.app/profile/' + post.author.handle + '/post/' + rkey;
    card.dataset.link = link;

    if (item.reason) {
      var repost = el('div', 'note-repost', ' Reposted');
      repost.insertAdjacentHTML('afterbegin', REPOST_SVG);
      card.appendChild(repost);
    }

    var header = el('header', 'note-header');
    if (post.author.avatar) {
      var avatar = el('img', 'note-avatar');
      avatar.src = post.author.avatar;
      avatar.alt = '';
      avatar.loading = 'lazy';
      avatar.decoding = 'async';
      avatar.width = 42;
      avatar.height = 42;
      header.appendChild(avatar);
    }
    var author = el('div', 'note-author');
    author.appendChild(
      el('span', 'note-author-name', post.author.displayName || post.author.handle)
    );
    author.appendChild(el('span', 'note-author-handle', '@' + post.author.handle));
    header.appendChild(author);

    var date = el('a', 'note-date');
    date.href = link;
    date.target = '_blank';
    date.rel = 'noopener noreferrer';
    date.textContent = new Date(post.record.createdAt).toLocaleDateString('en-US', {
      month: 'short',
      day: 'numeric',
      year: 'numeric',
    });
    var meta = el('div', 'note-meta');
    meta.appendChild(date);

    var copy = el('button', 'note-copy-link');
    copy.type = 'button';
    copy.dataset.link = date.href;
    copy.dataset.tip = 'Copy link';
    copy.setAttribute('aria-label', 'Copy link to post');
    copy.insertAdjacentHTML('afterbegin', LINK_SVG);
    meta.appendChild(copy);

    var open = el('a', 'note-open');
    open.href = link;
    open.target = '_blank';
    open.rel = 'noopener noreferrer';
    open.dataset.tip = 'Open on Bluesky';
    open.setAttribute('aria-label', 'Open on Bluesky');
    open.insertAdjacentHTML('afterbegin', OPEN_SVG);
    meta.appendChild(open);
    header.appendChild(meta);
    card.appendChild(header);

    card.appendChild(el('div', 'note-text', post.record.text));

    var embed = post.embed || {};
    var images = embed.images || (embed.media && embed.media.images);
    if (images && images.length) {
      var wrap = el(
        'div',
        'note-images' + (images.length > 1 ? ' note-images--multi' : '')
      );
      images.forEach(function (image) {
        var img = el('img');
        img.src = image.thumb;
        img.alt = image.alt || '';
        img.loading = 'lazy';
        img.decoding = 'async';
        wrap.appendChild(img);
      });
      card.appendChild(wrap);
    }

    var video =
      embed.playlist && embed.thumbnail
        ? embed
        : embed.media && embed.media.playlist && embed.media.thumbnail
          ? embed.media
          : null;
    if (video) {
      var videoLink = el('a', 'note-video');
      videoLink.href = link;
      videoLink.dataset.playlist = video.playlist;
      videoLink.target = '_blank';
      videoLink.rel = 'noopener noreferrer';
      videoLink.setAttribute('aria-label', 'Play video');
      var poster = el('img');
      poster.src = video.thumbnail;
      poster.alt = '';
      poster.loading = 'lazy';
      poster.decoding = 'async';
      videoLink.appendChild(poster);
      var play = el('span', 'note-video-play');
      play.insertAdjacentHTML('afterbegin', PLAY_SVG);
      videoLink.appendChild(play);
      card.appendChild(videoLink);
    }

    var external = embed.external;
    if (external && /^https?:\/\//i.test(external.uri)) {
      var linkCard = el('a', 'note-link-card');
      linkCard.href = external.uri;
      linkCard.target = '_blank';
      linkCard.rel = 'noopener noreferrer';
      linkCard.appendChild(el('span', 'note-link-title', external.title || external.uri));
      try {
        linkCard.appendChild(el('span', 'note-link-domain', new URL(external.uri).host));
      } catch (e) {
        /* unparseable URL — title alone is enough */
      }
      card.appendChild(linkCard);
    }

    return card;
  }

  var CHECK_SVG =
    '<svg viewBox="0 0 24 24" fill="none" stroke="currentColor" stroke-width="2" stroke-linecap="round" stroke-linejoin="round"><polyline points="20 6 9 17 4 12"></polyline></svg>';

  // Inline HLS playback: swap the thumbnail link for a <video> on click.
  // hls.js (self-hosted, data-hls) loads lazily on the first play; Safari
  // plays HLS natively and skips it.
  var hlsLoader = null;
  function loadHls() {
    if (window.Hls) return Promise.resolve();
    if (!hlsLoader) {
      hlsLoader = new Promise(function (resolve, reject) {
        var script = document.createElement('script');
        script.src = list.dataset.hls;
        script.onload = resolve;
        script.onerror = reject;
        document.head.appendChild(script);
      });
    }
    return hlsLoader;
  }

  function playVideo(videoLink) {
    var playlist = videoLink.dataset.playlist;
    var poster = videoLink.querySelector('img');
    var wrap = el('div', 'note-video');
    var player = document.createElement('video');
    player.controls = true;
    player.autoplay = true;
    player.playsInline = true;
    if (poster) player.poster = poster.src;
    wrap.appendChild(player);
    videoLink.replaceWith(wrap);
    if (player.canPlayType('application/vnd.apple.mpegurl')) {
      player.src = playlist;
      return;
    }
    loadHls()
      .then(function () {
        var hls = new window.Hls();
        hls.loadSource(playlist);
        hls.attachMedia(player);
      })
      .catch(function () {
        // player failed to load — fall back to the post on Bluesky
        window.open(videoLink.href, '_blank', 'noopener');
      });
  }

  list.addEventListener('click', function (event) {
    var videoLink = event.target.closest('.note-video[data-playlist]');
    if (videoLink) {
      event.preventDefault();
      playVideo(videoLink);
      return;
    }
    var btn = event.target.closest('.note-copy-link');
    if (!btn) {
      // whole-card click opens the post, unless an inner link/button was
      // the target or the user is selecting text
      var card = event.target.closest('.note-card');
      if (
        card &&
        card.dataset.link &&
        !event.target.closest('a, button') &&
        !String(window.getSelection())
      ) {
        window.open(card.dataset.link, '_blank', 'noopener');
      }
      return;
    }
    if (!navigator.clipboard) return;
    navigator.clipboard
      .writeText(btn.dataset.link)
      .then(function () {
        btn.innerHTML = CHECK_SVG;
        btn.setAttribute('aria-label', 'Link copied');
        setTimeout(function () {
          btn.innerHTML = LINK_SVG;
          btn.setAttribute('aria-label', 'Copy link to post');
        }, 1500);
      })
      .catch(function () {
        /* clipboard permission denied — leave the icon as-is */
      });
  });

  function paginate() {
    var cards = Array.prototype.slice.call(list.querySelectorAll('.note-card'));
    var PAGE_SIZE = 10;
    if (cards.length <= PAGE_SIZE) return;

    var shown = PAGE_SIZE;
    var btn = el('button', 'button notes-more', 'Show more');
    btn.type = 'button';

    function update() {
      cards.forEach(function (card, i) {
        card.style.display = i < shown ? '' : 'none';
      });
      if (shown >= cards.length) btn.remove();
    }

    btn.addEventListener('click', function () {
      shown += PAGE_SIZE;
      update();
    });

    update();
    list.after(btn);
  }

  fetch(url)
    .then(function (res) {
      return res.ok ? res.json() : Promise.reject(new Error(res.status));
    })
    .then(function (data) {
      var existing = {};
      list.querySelectorAll('.note-card').forEach(function (card) {
        existing[card.dataset.atid] = true;
      });
      var fresh = data.feed.filter(function (item) {
        return !existing[item.post.uri];
      });
      // feed is newest-first; prepend oldest fresh post first so the
      // newest ends up on top
      fresh.reverse().forEach(function (item) {
        list.prepend(buildCard(item));
      });
      if (fresh.length) {
        // covers build-time fetch failure: cards now exist, so drop the
        // "couldn't load posts" fallback if it rendered
        var empty = document.querySelector('.notes-empty');
        if (empty) empty.remove();
      }
    })
    .catch(function () {
      /* build-time content stands */
    })
    .finally(paginate);
});
