document.toggle_form = (link) ->
  $(".#{link}_form").children("form").toggle()

$(document).ready ->
  if $("#info-header").children().size() > 1
    $("#info-header").slideDown()
