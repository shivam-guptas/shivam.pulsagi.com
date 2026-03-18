(function () {
  var cache = {};

  function fetchPartial(path) {
    if (cache[path]) {
      return Promise.resolve(cache[path]);
    }

    return fetch(path, { credentials: 'same-origin' })
      .then(function (response) {
        if (!response.ok) {
          throw new Error('Failed to load partial: ' + path);
        }
        return response.text();
      })
      .then(function (html) {
        cache[path] = html;
        return html;
      });
  }

  function injectPartial(target, html) {
    if (!target) {
      return;
    }
    target.innerHTML = html;
  }

  function loadLayout() {
    var headerTarget = document.querySelector('[data-layout="header"]');
    var footerTarget = document.querySelector('[data-layout="footer"]');
    var tasks = [];

    if (headerTarget) {
      tasks.push(fetchPartial('/partials/header.html').then(function (html) {
        injectPartial(headerTarget, html);
      }));
    }

    if (footerTarget) {
      tasks.push(fetchPartial('/partials/footer.html').then(function (html) {
        injectPartial(footerTarget, html);
      }));
    }

    return Promise.all(tasks).then(function () {
      document.dispatchEvent(new CustomEvent('site:layout-ready'));
    }).catch(function () {
      document.dispatchEvent(new CustomEvent('site:layout-error'));
    });
  }

  window.SiteLayout = {
    load: loadLayout
  };

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', loadLayout, { once: true });
  } else {
    loadLayout();
  }
}());
