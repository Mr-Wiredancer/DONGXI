Paperclip.interpolates :assets_host  do |attachment, style|
  request = Thread.current[:current_request]
  if request
    "#{request.protocol}#{request.host_with_port}"
  else
    ""
  end
end

Paperclip::Attachment.default_options.update({
  :hash_secret => "DongXi"
})
