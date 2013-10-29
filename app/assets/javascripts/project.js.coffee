$ ->
  $('ul.banner a').click ->
    $('form input[name="next"]').val($(@).attr('href').substring(1))
    $('form').submit()

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
