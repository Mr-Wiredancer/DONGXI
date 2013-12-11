# ProjectController 下JS功能
window.Project =

  init: ->
    $("#add_volunteer").on "click", ->
      Project.addVolunteerRequest()
      false
    $("#remove_volunteer").on "click", ->
      Project.removeVolunteerRequest()
      false

  addVolunteerRequest : ->
    user_id = $('#user_id').val()
    project_id = $('#project_id').val()
    $.ajax
      url   : "/projects/#{project_id}/add_volunteer",
      type  : "POST",
      data  : {
        user_id: user_id
      }
      success: (result, status, xhr) ->
        $("#volunteer_amount").html(result["amount"])
        $("#add_volunteer").hide()
        $("#remove_volunteer").show()

  removeVolunteerRequest : ->
    user_id = $('#user_id').val()
    project_id = $('#project_id').val()
    $.ajax
      url   : "/projects/#{project_id}/remove_volunteer",
      type  : "POST",
      data  : {
        user_id: user_id
      }
      success: (result, status, xhr) ->
        $("#volunteer_amount").html(result["amount"])
        $("#remove_volunteer").hide()
        $("#add_volunteer").show()

  commentCallback : (success, msg) ->

$ ->
  $('ul.banner a.editable').click (e)->
    $form = $('.project-edit-form form')
    if $form.length > 0
      e.preventDefault()
      $form.find('input[name="next"]').val($(@).data('step'))
      $form.submit()
    else
      true

  $('button#repost').click ->
    print_log = (data) -> console.log(data)
    is_comment = if $("input#is_comment").is(":checked") then 1 else 0
    $.post('https://api.weibo.com/2/statuses/repost.json', {
      access_token: $('input#access_token').val(), # encodeURIComponent ?
      id: '3637946596783717',
      status: $("textarea#status").val(),
      is_comment: is_comment
    },print_log,"json").done ->
      window.location.reload()

  # 根据dropdown调整单位
  $('#project_basic_info_attributes_raise_type').change ->
    $('#raise_type_unit span').toggle()

$(document).ready ->
  if $("body").attr("id") in ["projects"]
    Project.init()

