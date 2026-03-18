(function () {
  var STYLE_SELECTOR = 'link[rel="stylesheet"], style';
  var META_SELECTORS = [
    'meta[name="description"]',
    'meta[name="keywords"]',
    'meta[name="author"]',
    'meta[name="robots"]',
    'meta[property="og:title"]',
    'meta[property="og:description"]',
    'meta[property="og:url"]',
    'meta[property="og:type"]',
    'meta[property="og:site_name"]',
    'meta[property="og:image"]',
    'meta[name="twitter:card"]',
    'meta[name="twitter:title"]',
    'meta[name="twitter:description"]',
    'meta[name="twitter:image"]'
  ];
  var cache = new Map();
  var activeController = null;

  function normalizePath(pathname) {
    if (!pathname) {
      return '/';
    }
    return pathname.length > 1 ? pathname.replace(/\/+$/, '') : pathname;
  }

  function shouldMarkResources(pathname) {
    return pathname === '/resources.html' || pathname === '/AI-blog' || pathname.indexOf('/AI-blog/') === 0 || pathname === '/salesforce-blog' || pathname.indexOf('/salesforce-blog/') === 0 || pathname === '/codex-claude-salesforce-guide' || pathname.indexOf('/codex-claude-salesforce-guide/') === 0 || pathname === '/agentforce-blog' || pathname.indexOf('/agentforce-blog/') === 0;
  }

  function setActiveNavigation(urlLike) {
    var currentUrl = new URL(urlLike, window.location.origin);
    var currentPath = normalizePath(currentUrl.pathname);
    var links = document.querySelectorAll('.nav-links a, .footer-nav a');

    links.forEach(function (link) {
      var href = link.getAttribute('href');
      if (!href || href.charAt(0) === '#') {
        link.removeAttribute('aria-current');
        return;
      }

      var linkUrl = new URL(href, window.location.origin);
      var linkPath = normalizePath(linkUrl.pathname);
      var isActive = false;

      if (linkPath === '/resources.html') {
        isActive = shouldMarkResources(currentPath);
      } else {
        isActive = linkPath === currentPath;
      }

      if (isActive) {
        link.setAttribute('aria-current', 'page');
      } else {
        link.removeAttribute('aria-current');
      }
    });
  }

  function initResourcesSearch(root) {
    var scope = root || document;
    var searchInput = scope.querySelector('#resourceSearch');
    if (!searchInput || searchInput.dataset.routerBound === 'true') {
      return;
    }

    searchInput.dataset.routerBound = 'true';
    var cards = Array.prototype.slice.call(scope.querySelectorAll('[data-resource-item]'));
    var count = scope.querySelector('#resourceCount');
    var empty = scope.querySelector('#resourceEmpty');

    function normalize(value) {
      return (value || '')
        .toLowerCase()
        .replace(/[^a-z0-9\s]/g, ' ')
        .replace(/\s+/g, ' ')
        .trim();
    }

    function updateResults() {
      var query = normalize(searchInput.value || '');
      var terms = query ? query.split(' ') : [];
      var visible = 0;

      cards.forEach(function (card) {
        var haystack = normalize((card.getAttribute('data-search') || '') + ' ' + (card.textContent || ''));
        var matched = !terms.length || terms.every(function (term) {
          return haystack.indexOf(term) !== -1;
        });

        card.classList.toggle('is-hidden', !matched);
        card.setAttribute('aria-hidden', matched ? 'false' : 'true');
        if (matched) {
          visible += 1;
        }
      });

      if (count) {
        count.textContent = visible + (visible === 1 ? ' resource' : ' resources');
      }
      if (empty) {
        empty.classList.toggle('is-visible', visible === 0);
      }
    }

    searchInput.addEventListener('input', updateResults);
    updateResults();
  }

  function updateNode(selector, targetDoc, attributeName, resolver) {
    var currentNode = document.head.querySelector(selector);
    var targetNode = targetDoc.head.querySelector(selector);

    if (!targetNode) {
      if (currentNode) {
        currentNode.remove();
      }
      return;
    }

    if (!currentNode) {
      currentNode = document.createElement(targetNode.tagName.toLowerCase());
      if (targetNode.name) {
        currentNode.setAttribute('name', targetNode.getAttribute('name'));
      }
      if (targetNode.getAttribute('property')) {
        currentNode.setAttribute('property', targetNode.getAttribute('property'));
      }
      if (targetNode.getAttribute('rel')) {
        currentNode.setAttribute('rel', targetNode.getAttribute('rel'));
      }
      document.head.appendChild(currentNode);
    }

    var nextValue = targetNode.getAttribute(attributeName) || '';
    currentNode.setAttribute(attributeName, resolver ? resolver(nextValue) : nextValue);
  }

  function syncHead(targetDoc, targetUrl) {
    document.documentElement.lang = targetDoc.documentElement.lang || 'en';
    document.title = targetDoc.title;

    updateNode('link[rel="canonical"]', targetDoc, 'href', function (value) {
      return new URL(value || targetUrl.href, targetUrl.href).href;
    });

    META_SELECTORS.forEach(function (selector) {
      updateNode(selector, targetDoc, 'content');
    });

    document.head.querySelectorAll(STYLE_SELECTOR).forEach(function (node) {
      node.remove();
    });

    Array.prototype.slice.call(targetDoc.head.querySelectorAll(STYLE_SELECTOR)).forEach(function (node) {
      var clone = node.cloneNode(true);
      if (clone.tagName.toLowerCase() === 'link') {
        clone.href = new URL(node.getAttribute('href'), targetUrl.href).href;
      }
      document.head.appendChild(clone);
    });

    document.head.querySelectorAll('script[type="application/ld+json"]').forEach(function (node) {
      node.remove();
    });

    Array.prototype.slice.call(targetDoc.head.querySelectorAll('script[type="application/ld+json"]')).forEach(function (node) {
      document.head.appendChild(node.cloneNode(true));
    });
  }

  function scrollToTarget(targetUrl) {
    if (targetUrl.hash) {
      var element = document.getElementById(targetUrl.hash.slice(1));
      if (element) {
        element.scrollIntoView();
        return;
      }
    }
    window.scrollTo(0, 0);
  }

  function dispatchNavigationEvent(url) {
    document.dispatchEvent(new CustomEvent('site:navigation-complete', {
      detail: { url: url.href }
    }));
  }

  function applyPage(targetDoc, targetUrl, historyMode) {
    syncHead(targetDoc, targetUrl);

    var nextMain = targetDoc.querySelector('main');
    var currentMain = document.querySelector('main');
    if (!nextMain || !currentMain) {
      window.location.href = targetUrl.href;
      return;
    }

    currentMain.replaceWith(document.importNode(nextMain, true));

    if (historyMode === 'push') {
      window.history.pushState({ url: targetUrl.href }, '', targetUrl.href);
    } else {
      window.history.replaceState({ url: targetUrl.href }, '', targetUrl.href);
    }

    setActiveNavigation(targetUrl.href);
    initResourcesSearch(document);
    scrollToTarget(targetUrl);

    if (typeof window.gtag === 'function') {
      window.gtag('config', 'G-S55MNPYJF8', {
        page_title: document.title,
        page_location: targetUrl.href,
        page_path: targetUrl.pathname + targetUrl.search
      });
    }

    dispatchNavigationEvent(targetUrl);
  }

  function fetchDocument(targetUrl, signal) {
    var cacheKey = targetUrl.href;
    if (cache.has(cacheKey)) {
      return Promise.resolve(cache.get(cacheKey).cloneNode(true));
    }

    return fetch(cacheKey, {
      signal: signal,
      credentials: 'same-origin'
    }).then(function (response) {
      if (!response.ok) {
        throw new Error('Navigation failed with status ' + response.status);
      }
      return response.text();
    }).then(function (html) {
      var parser = new DOMParser();
      var doc = parser.parseFromString(html, 'text/html');
      cache.set(cacheKey, doc.cloneNode(true));
      return doc;
    });
  }

  function navigate(urlLike, options) {
    var settings = options || {};
    var historyMode = settings.historyMode || 'push';
    var targetUrl = new URL(urlLike, window.location.href);

    if (activeController) {
      activeController.abort();
    }

    activeController = new AbortController();

    return fetchDocument(targetUrl, activeController.signal)
      .then(function (targetDoc) {
        applyPage(targetDoc, targetUrl, historyMode);
      })
      .catch(function (error) {
        if (error && error.name === 'AbortError') {
          return;
        }
        window.location.href = targetUrl.href;
      });
  }

  function shouldHandleNavigation(anchor, event) {
    if (!anchor || event.defaultPrevented || event.button !== 0) {
      return false;
    }

    if (anchor.target && anchor.target !== '_self') {
      return false;
    }

    if (anchor.hasAttribute('download')) {
      return false;
    }

    if (event.metaKey || event.ctrlKey || event.shiftKey || event.altKey) {
      return false;
    }

    var rawHref = anchor.getAttribute('href');
    if (!rawHref || rawHref.indexOf('mailto:') === 0 || rawHref.indexOf('tel:') === 0 || rawHref.indexOf('javascript:') === 0) {
      return false;
    }

    var targetUrl = new URL(anchor.href, window.location.href);
    if (targetUrl.origin !== window.location.origin) {
      return false;
    }

    var currentPath = normalizePath(window.location.pathname);
    var targetPath = normalizePath(targetUrl.pathname);
    var sameDocument = currentPath === targetPath && window.location.search === targetUrl.search;
    if (sameDocument) {
      return false;
    }

    return true;
  }

  document.addEventListener('click', function (event) {
    var anchor = event.target.closest('a');
    if (!shouldHandleNavigation(anchor, event)) {
      return;
    }

    event.preventDefault();
    navigate(anchor.href, { historyMode: 'push' });
  });

  window.addEventListener('popstate', function () {
    navigate(window.location.href, { historyMode: 'replace' });
  });

  if (!window.history.state || !window.history.state.url) {
    window.history.replaceState({ url: window.location.href }, '', window.location.href);
  }

  setActiveNavigation(window.location.href);
  initResourcesSearch(document);
  window.SiteRouter = { navigate: navigate };
}());
