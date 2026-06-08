(function(){
  function hidePreloader(){
    var el = document.getElementById('preloader-overlay');
    if(!el) return;
    el.classList.add('hide');
    setTimeout(function(){ el.remove(); }, 400);
  }

  // If page fully loads, hide preloader
  if (document.readyState === 'complete') {
    hidePreloader();
  } else {
    window.addEventListener('load', hidePreloader);
    // Fallback: hide after 6s
    setTimeout(hidePreloader, 6000);
  }
})();
