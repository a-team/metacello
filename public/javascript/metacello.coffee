document.toggle_form = (link) ->
  $(".#{link}_form").children("form").toggle()

$(document).ready ->
  if $("#info-header").children().size() > 1
    $("#info-header").slideDown()
  $(".add-system-link").onClick ->
    # %label{:for => "project[compatibility][#{idx}][system]"} Smalltalk:
    # %input{:type => "textbox", :name => "project[compatibility][#{idx}][system]", :value => "#{h(system)}"}
    # %label{:for => "project[compatibility][#{idx}][versions]"} Versions:
    # %input{:type => "textbox", :name => "project[compatibility][#{idx}][versions]", :value => "#{h(project.compatibility[system])}"}
    false
