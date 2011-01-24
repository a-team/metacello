(function() {
  var Metacello;
  Metacello = {};
  Metacello.getAvailableProjects = function() {
    return $.getJSON("/projects/names", function(data) {
      return $("#search-box").autocomplete("option", "source", data);
    });
  };
  $(document).ready(function() {
    window.Metacello = Metacello;
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
      source: [],
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
