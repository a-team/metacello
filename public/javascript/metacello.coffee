Metacello = {}

Metacello.availableProjects = ->
  $("#available-projects").data('names')

Metacello.getAvailableProjects = ->
  $.getJSON("/projects/names", (data) ->
    $('#available-projects').data('names', data))

$(document).ready ->
  document.Metacello = Metacello
  Metacello.getAvailableProjects()
  $(".date").prettyDate()
  $("#account-edit").click ->
    $(".account_form").children("form").toggle()
    false
  $("#login-signup").click ->
    $(".login_form").children("form").toggle()
    false
  $("#search-box").autocomplete({
      source: Metacello.availableProjects,
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
