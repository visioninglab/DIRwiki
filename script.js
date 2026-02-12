/* ============================================================
   DIR Case Study Wiki — Shared JavaScript
   ============================================================ */

(function () {
  'use strict';

  /* --- Accessibility: add ARIA attributes on load --- */
  function initAccessibility() {
    // Section headers: keyboard support + ARIA
    document.querySelectorAll('.section-header').forEach(function (header) {
      header.setAttribute('role', 'button');
      header.setAttribute('tabindex', '0');
      var section = header.parentElement;
      header.setAttribute('aria-expanded', section.classList.contains('collapsed') ? 'false' : 'true');

      // Keyboard: Enter or Space to toggle
      header.addEventListener('keydown', function (e) {
        if (e.key === 'Enter' || e.key === ' ') {
          e.preventDefault();
          toggleSection(header);
        }
      });
    });

    // Hide emoji icons from screen readers
    document.querySelectorAll('.section-icon, .about-section-icon').forEach(function (icon) {
      icon.setAttribute('aria-hidden', 'true');
    });
  }

  /* --- Section toggle --- */
  function toggleSection(header) {
    var section = header.parentElement;
    section.classList.toggle('collapsed');
    var expanded = !section.classList.contains('collapsed');
    header.setAttribute('aria-expanded', String(expanded));
  }
  window.toggleSection = toggleSection;

  /* --- Table of Contents: scroll highlighting --- */
  function initToc() {
    var tocLinks = document.querySelectorAll('.toc a');
    var sections = document.querySelectorAll('.section[id]');
    if (!tocLinks.length || !sections.length) return;

    function updateToc() {
      var current = '';
      sections.forEach(function (s) {
        if (s.getBoundingClientRect().top <= 100) current = s.id;
      });
      tocLinks.forEach(function (a) {
        a.classList.toggle('active', a.getAttribute('href') === '#' + current);
      });
    }
    window.addEventListener('scroll', updateToc, { passive: true });
    updateToc();
  }

  /* --- Mobile TOC toggle --- */
  function initMobileToc() {
    var toc = document.querySelector('.toc');
    if (!toc) return;

    var links = toc.querySelectorAll('a');
    if (!links.length) return;

    var linksWrapper = document.createElement('div');
    linksWrapper.className = 'toc-links';
    links.forEach(function (a) { linksWrapper.appendChild(a); });
    toc.appendChild(linksWrapper);

    var toggle = document.createElement('button');
    toggle.className = 'toc-toggle';
    toggle.textContent = 'Show contents';
    toggle.setAttribute('aria-expanded', 'false');
    toc.appendChild(toggle);

    toggle.addEventListener('click', function () {
      toc.classList.toggle('open');
      var open = toc.classList.contains('open');
      toggle.textContent = open ? 'Hide contents' : 'Show contents';
      toggle.setAttribute('aria-expanded', String(open));
    });
  }

  /* --- Homepage: multi-dimensional filters --- */
  var activeFilters = { sector: 'all', hazard: 'all' };
  var searchQuery = '';

  function setFilter(dimension, value, btn) {
    activeFilters[dimension] = value;
    var group = btn.parentElement;
    group.querySelectorAll('.filter-btn').forEach(function (b) { b.classList.remove('active'); });
    btn.classList.add('active');
    applyFilters();
    updateURL();
    updateResetBtn();
  }
  window.setFilter = setFilter;

  function resetAllFilters() {
    activeFilters.sector = 'all';
    activeFilters.hazard = 'all';
    searchQuery = '';
    var searchInput = document.getElementById('studySearch');
    if (searchInput) searchInput.value = '';
    activateButton('sectorFilter', 'all');
    activateButton('hazardFilter', 'all');
    applyFilters();
    updateURL();
    updateResetBtn();
  }
  window.resetAllFilters = resetAllFilters;

  function updateResetBtn() {
    var btn = document.getElementById('resetFilters');
    if (!btn) return;
    var hasFilters = activeFilters.sector !== 'all' || activeFilters.hazard !== 'all' || searchQuery !== '';
    btn.style.display = hasFilters ? '' : 'none';
  }

  function applyFilters() {
    var sector = activeFilters.sector;
    var hazard = activeFilters.hazard;
    var query = searchQuery.toLowerCase();
    var visibleCount = 0;

    document.querySelectorAll('.study-card').forEach(function (card) {
      var matchSector = (sector === 'all' || card.dataset.sector === sector);
      var matchHazard = (hazard === 'all' || (card.dataset.hazard && card.dataset.hazard.split(' ').indexOf(hazard) !== -1));
      var matchSearch = !query || card.textContent.toLowerCase().indexOf(query) !== -1;
      var visible = matchSector && matchHazard && matchSearch;
      card.style.display = visible ? '' : 'none';
      if (visible) visibleCount++;
    });

    var noResults = document.getElementById('noResults');
    if (noResults) {
      noResults.style.display = visibleCount === 0 ? 'block' : 'none';
    }
  }

  function initSearch() {
    var input = document.getElementById('studySearch');
    if (!input) return;
    input.addEventListener('input', function () {
      searchQuery = input.value.trim();
      applyFilters();
      updateResetBtn();
    });
  }

  /* --- URL parameter support (homepage) --- */
  function readURL() {
    var params = new URLSearchParams(window.location.search);
    var sector = params.get('sector');
    var hazard = params.get('hazard');

    if (sector) {
      activeFilters.sector = sector;
      activateButton('sectorFilter', sector);
    }
    if (hazard) {
      activeFilters.hazard = hazard;
      activateButton('hazardFilter', hazard);
    }

    if (sector || hazard) {
      applyFilters();
      updateResetBtn();
    }
  }

  function activateButton(groupId, value) {
    var group = document.getElementById(groupId);
    if (!group) return;
    group.querySelectorAll('.filter-btn').forEach(function (btn) {
      btn.classList.remove('active');
      var onclick = btn.getAttribute('onclick') || '';
      if (onclick.indexOf("'" + value + "'") !== -1) {
        btn.classList.add('active');
      }
      if (value === 'all' && onclick.indexOf("'all'") !== -1) {
        btn.classList.add('active');
      }
    });
  }

  function updateURL() {
    var params = new URLSearchParams();
    if (activeFilters.sector !== 'all') params.set('sector', activeFilters.sector);
    if (activeFilters.hazard !== 'all') params.set('hazard', activeFilters.hazard);
    var qs = params.toString();
    var url = window.location.pathname + (qs ? '?' + qs : '');
    history.replaceState(null, '', url);
  }

  /* --- Glossary: filter terms --- */
  function initGlossary() {
    var input = document.getElementById('glossarySearch');
    if (!input) return;

    input.addEventListener('input', function () {
      var query = input.value.trim().toLowerCase();
      var groups = document.querySelectorAll('.glossary-group');
      var anyVisible = false;

      groups.forEach(function (group) {
        var dts = group.querySelectorAll('dt');
        var dds = group.querySelectorAll('dd');
        var groupVisible = false;

        for (var i = 0; i < dts.length; i++) {
          var text = dts[i].textContent.toLowerCase() + ' ' + dds[i].textContent.toLowerCase();
          var match = !query || text.indexOf(query) !== -1;
          dts[i].style.display = match ? '' : 'none';
          dds[i].style.display = match ? '' : 'none';
          if (match) groupVisible = true;
        }

        group.style.display = groupVisible ? '' : 'none';
        if (groupVisible) anyVisible = true;
      });

      var noResults = document.getElementById('glossaryNoResults');
      if (noResults) {
        noResults.style.display = anyVisible ? 'none' : 'block';
      }
    });
  }

  /* --- Initialize on DOM ready --- */
  document.addEventListener('DOMContentLoaded', function () {
    initAccessibility();
    initToc();
    initMobileToc();

    // Homepage: search, filters, URL params
    if (document.getElementById('studiesGrid')) {
      initSearch();
      readURL();
    }

    // Glossary: filter
    if (document.getElementById('glossaryList')) {
      initGlossary();
    }
  });
})();
