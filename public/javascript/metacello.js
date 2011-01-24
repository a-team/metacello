(function() {
  var Metacello;
  Metacello = {};
  Metacello.availableProjectsSearch = function(box) {
    $(box).autocomplete({
      source: [],
      minLength: 0
    });
    return $.getJSON("/projects/names", function(data) {
      return $(box).autocomplete("option", "source", data);
    });
  };
  Metacello.addTextboxLink = function(a) {
    var count, name_prefix;
    name_prefix = $(a).parent().attr("for").replace("[0]", "");
    count = $("input,select").filter(function() {
      return $(this).attr("name").search(name_prefix.replace(/[\[\]]/g, "\\$&")) > -1;
    }).size() - 1;
    $(a).data("count", count);
    return $(a).click(function() {
      var input, name;
      count = $(this).data("count");
      name = $(this).parent().attr("for").replace("[0]", "[" + count + "]");
      input = $("[name='" + name + "']");
      input.clone().attr("name", name.replace("[" + count + "]", "[" + (count + 1) + "]")).attr("value", "").insertAfter(input);
      $(this).data("count", count + 1);
      return false;
    });
  };
  $(document).ready(function() {
    window.Metacello = Metacello;
    Metacello.availableProjectsSearch("#search-box");
    Metacello.addTextboxLink("a.add-box-link");
    $(".date").prettyDate();
    $("#account-edit").click(function() {
      $(".account_form").children("form").toggle();
      return false;
    });
    $("#login-signup").click(function() {
      $(".login_form").children("form").toggle();
      return false;
    });
    if ($("#info-header").children().size() > 1) {
      return $("#info-header").slideDown();
    }
  });
}).call(this);
