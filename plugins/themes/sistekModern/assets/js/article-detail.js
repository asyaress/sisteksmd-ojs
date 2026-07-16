/**
 * Article detail tab navigation for SISTEK Modern theme.
 */
(function () {
  function initArticleTabs(root) {
    var tabButtons = root.querySelectorAll('.jkc-article-tabs__btn[data-tab-target]');
    var tabPanels = root.querySelectorAll('.jkc-article-tabpanel[data-tab-panel]');

    if (!tabButtons.length || !tabPanels.length) {
      return;
    }

    function activateTab(target) {
      tabButtons.forEach(function (button) {
        var isActive = button.getAttribute('data-tab-target') === target;
        button.classList.toggle('is-active', isActive);
        button.setAttribute('aria-selected', isActive ? 'true' : 'false');
      });

      tabPanels.forEach(function (panel) {
        var isActive = panel.getAttribute('data-tab-panel') === target;
        panel.classList.toggle('is-active', isActive);
        if (isActive) {
          panel.removeAttribute('hidden');
        } else {
          panel.setAttribute('hidden', 'hidden');
        }
      });
    }

    tabButtons.forEach(function (button) {
      button.addEventListener('click', function () {
        activateTab(button.getAttribute('data-tab-target'));
      });
    });
  }

  document.addEventListener('DOMContentLoaded', function () {
    document.querySelectorAll('[data-jkc-article-tabs]').forEach(initArticleTabs);
  });
})();
