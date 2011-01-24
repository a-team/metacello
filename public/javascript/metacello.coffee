Metacello = {}

Metacello.getAvailableProjects = ->
  $.getJSON("/projects/names", (data) ->
    $( "#search-box" ).autocomplete("option", "source", data))

$(document).ready ->
  window.Metacello = Metacello
  Metacello.getAvailableProjects()
  $(".date").prettyDate()
  $("#account-edit").click ->
    $(".account_form").children("form").toggle()
    false
  $("#login-signup").click ->
    $(".login_form").children("form").toggle()
    false
  $("#search-box").autocomplete({
      source: [],
      minLength: 0
  })
  if $("#info-header").children().size() > 1
    $("#info-header").slideDown()
  $(".add-system-link").click ->
    # %label{:for => "project[compatibility][#{idx}][system]"} Smalltalk:
    # %input{:type => "textbox", :name => "project[compatibility][#{idx}][system]", :value => "#{h(system)}"}
    # %label{:for => "project[compatibility][#{idx}][versions]"} Versions:
    # %input{:type => "textbox", :name => "project[compatibility][#{idx}][versions]", :value => "#{h(project.compatibility[system])}"}
    false
