(function () {
  const tabSets = document.querySelectorAll('.jkc-articles-showcase');

  if (!tabSets.length) {
    return;
  }

  tabSets.forEach((showcase) => {
    const tabs = Array.from(showcase.querySelectorAll('.jkc-articles-tab'));
    const panels = Array.from(showcase.querySelectorAll('.jkc-articles-panel'));

    const activateTab = (targetId) => {
      tabs.forEach((tab) => {
        const isActive = tab.dataset.target === targetId;
        tab.classList.toggle('is-active', isActive);
        tab.setAttribute('aria-selected', isActive ? 'true' : 'false');
      });

      panels.forEach((panel) => {
        const isActive = panel.id === targetId;
        panel.classList.toggle('is-active', isActive);
        if (isActive) {
          panel.removeAttribute('hidden');
        } else {
          panel.setAttribute('hidden', 'hidden');
        }
      });
    };

    tabs.forEach((tab) => {
      tab.addEventListener('click', () => activateTab(tab.dataset.target));
    });

    showcase.querySelectorAll('.jkc-slider-arrow').forEach((button) => {
      button.addEventListener('click', () => {
        const trackId = button.getAttribute('data-track');
        const track = trackId ? showcase.querySelector('#' + trackId) : null;
        if (!track) {
          return;
        }

        const firstCard = track.querySelector('.jkc-article-card');
        const step = firstCard ? firstCard.getBoundingClientRect().width + 22 : track.clientWidth * 0.85;
        const direction = button.classList.contains('jkc-slider-arrow--prev') ? -1 : 1;

        track.scrollBy({
          left: direction * step,
          behavior: 'smooth'
        });
      });
    });
  });
})();
