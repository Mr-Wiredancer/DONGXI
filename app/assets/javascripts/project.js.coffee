$ ->
  $('ul.banner a').click ->
    $('form input[name="next"]').val($(@).attr('href').substring(1))
    $('form').submit()
