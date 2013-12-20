# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $("form#new_user").bind "ajax:success", (e, data, status, xhr) ->
    if data.success
      window.location.reload()
    else
      if data
        error = data.errors[0]
      else
        error = 'Du musst deinen Account aktivieren, bevor du dich anmelden kannst.'
      $(".messages").html('<div class="alert alert-danger">
      <button type="button" class="close" data-dismiss="alert" aria-hidden="true">&times;</button>
      <div>'+error+'</div></div>')