class HomeController < ApplicationController
  def index
    @project = Project.first
    oauth_retrieve
    #status_retrieve("3635973692630941") # add real sid later
  end

  private
  def oauth_retrieve
    user = current_user
    unless user.blank?
      authorization = user.authorizations.first
      unless authorization.blank?
        uid = authorization.uid
        client = OAuth2::Client.new(ENV["WEIBO_APPKEY"], ENV["WEIBO_APPSECRET"], :site => 'http://api.weibo.com')
        response = client.request(:get, "https://api.weibo.com/2/users/show.json", :params => { :uid => uid, :access_token => ENV["WEIBO_ACCESS_TOKEN"] })
        @weibo_user = JSON.parse(response.body)
      end
    end
  end

  #def status_retrieve(sid)
    #client = OAuth2::Client.new(ENV["WEIBO_APPKEY"], ENV["WEIBO_APPSECRET"], :site => 'http://api.weibo.com')
    #response = client.request(:get, "https://api.weibo.com/2/statuses/show.json", :params => { id: sid, :access_token => ENV["WEIBO_ACCESS_TOKEN"] })
    #@status = JSON.parse(response.body)
  #end
end
