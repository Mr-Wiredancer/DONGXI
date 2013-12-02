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

  def oauth_retrieve(uid)
    begin
      client = OAuth2::Client.new(ENV["WEIBO_APPKEY"], ENV["WEIBO_APPSECRET"], :site => 'http://api.weibo.com')
      response = client.request(:get, "https://api.weibo.com/2/users/show.json", :params => { :uid => uid, :access_token => ENV["WEIBO_ACCESS_TOKEN"] })
      JSON.parse(response.body)
    rescue => e # TODO: any need to specify the error: Faraday::xxx ?
      {}
    end
  end

  def status_retrieve(sid)
    begin
      client = OAuth2::Client.new(ENV["WEIBO_APPKEY"], ENV["WEIBO_APPSECRET"], :site => 'http://api.weibo.com')
      response = client.request(:get, "https://api.weibo.com/2/statuses/show.json", :params => { id: sid, access_token: ENV["WEIBO_ACCESS_TOKEN"] })
      JSON.parse(response.body)
    rescue => e
      {}
    end
  end

  def volunteer?(project)
    return false if project.blank? or current_user.blank?
    project.volunteer_ids.include?(current_user.id)
  end

end
