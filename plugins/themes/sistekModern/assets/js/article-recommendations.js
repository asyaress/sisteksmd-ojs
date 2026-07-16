(function () {
  document.querySelectorAll('.jkc-article-rec-showcase').forEach(function (showcase) {
    showcase.querySelectorAll('.jkc-slider-arrow').forEach(function (button) {
      button.addEventListener('click', function () {
        var trackId = button.getAttribute('data-track');
        var track = trackId ? document.getElementById(trackId) : null;
        if (!track) {
          return;
        }

        var firstCard = track.querySelector('.jkc-rec-cover-card');
        var step = firstCard ? firstCard.getBoundingClientRect().width + 18 : track.clientWidth * 0.8;
        var direction = button.classList.contains('jkc-slider-arrow--prev') ? -1 : 1;

        track.scrollBy({
          left: direction * step,
          behavior: 'smooth'
        });
      });
    });
  });
})();
