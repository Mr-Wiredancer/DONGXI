module ApplicationHelper
  def devise_mapping
    Devise.mappings[:user]
    end
  def resource_name
    devise_mapping.name
  end
  def resource_class
    devise_mapping.to || User
  end

  def status_retrieve(sid)
    client = OAuth2::Client.new(ENV["WEIBO_APPKEY"], ENV["WEIBO_APPSECRET"], :site => 'http://api.weibo.com')
    response = client.request(:get, "https://api.weibo.com/2/statuses/show.json", :params => { id: sid, :access_token => ENV["WEIBO_ACCESS_TOKEN"] })
    @status = JSON.parse(response.body)
  end

end
