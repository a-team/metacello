Metacello = {}

Metacello.availableProjectsSearch = (box) ->
  $(box).autocomplete({ source: [], minLength: 0, delay: 0, position: { my : "right top", at: "right bottom" } })
  $.getJSON("/projects/names", (data) ->
    $(box).autocomplete("option", "source", data))
  $(box).keypress (event) ->
    if event.keyCode == 13
      document.location.pathname = $(this).attr("value")
      false

Metacello.addTextboxLink = (a) ->
  # First, get the existing textboxes for this link to get the count
  if $("a.add-box-link").size() > 0
    name_prefix = $(a).parent().attr("for").replace("[0]", "")
    count = $("input,select").filter ->
      $(this).attr("name").search(name_prefix.replace(/[\[\]]/g, "\\$&")) > -1
    .size() - 1
    $(a).data("count", count)
    # Now, set a handler to add a textbox and increase the count on click
    $(a).click ->
      count = $(this).data("count")
      name = $(this).parent().attr("for").replace("[0]", "[#{count}]")
      input = $("[name='#{name}']")
      input.clone().
          attr("name", name.replace("[#{count}]", "[#{count + 1}]")).
          attr("value", "").
          insertAfter(input)
      $(this).data("count", count + 1)
      false

$(document).ready ->
  window.Metacello = Metacello
  Metacello.availableProjectsSearch("#search-box")
  Metacello.addTextboxLink("a.add-box-link")
  $(".date").prettyDate()
  $("#account-edit").click ->
    $(".account_form").children("form").toggle()
    false
  $("#login-signup").click ->
    $(".login_form").children("form").toggle()
    false
  if $("#info-header").children().size() > 1
    $("#info-header").slideDown()
