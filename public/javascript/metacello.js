(function() {
  document.toggle_form = function(link) {
    return $("." + link + "_form").children("form").toggle();
  };
  $(document).ready(function() {
    if ($("#info-header").children().size() > 1) {
      $("#info-header").slideDown();
    }
    return $(".add-system-link").onClick(function() {
      return false;
    });
  });
}).call(this);
