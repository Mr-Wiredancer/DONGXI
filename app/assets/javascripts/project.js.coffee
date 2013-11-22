# ProjectController 下JS功能
window.Project =
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

