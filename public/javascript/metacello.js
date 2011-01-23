(function() {
  var Metacello;
  Metacello = {};
  Metacello.availableProjects = function() {
    return $("#available-projects").data('names');
  };
  Metacello.getAvailableProjects = function() {
    return $.getJSON("/projects/names", function(data) {
      return $('#available-projects').data('names', data);
    });
  };
  $(document).ready(function() {
    document.Metacello = Metacello;
    Metacello.getAvailableProjects();
    $(".date").prettyDate();
    $("#account-edit").click(function() {
      $(".account_form").children("form").toggle();
      return false;
    });
    $("#login-signup").click(function() {
      $(".login_form").children("form").toggle();
      return false;
    });
    $("#search-box").autocomplete({
      source: Metacello.availableProjects,
      minLength: 0
    });
    if ($("#info-header").children().size() > 1) {
      $("#info-header").slideDown();
    }
    return $(".add-system-link").click(function() {
      return false;
    });
  });
}).call(this);
