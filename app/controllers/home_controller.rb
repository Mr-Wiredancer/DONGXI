class HomeController < ApplicationController
  def index
    @profile = Profile.first
    oauth_retrieve
  end

  private
  def oauth_retrieve
    user = current_user
    unless user.blank?
      authorization = user.authorizations.first
      unless authorization.blank?
        uid = authorization.uid
        client = OAuth2::Client.new("2267569622", "ebc1f1cdae0ae6f17f85908ccc871edb", :site => 'http://api.weibo.com')
        response = client.request(:get, "https://api.weibo.com/2/users/show.json", :params => { :uid => uid, :access_token => ENV["WEIBO_ACCESS_TOKEN"] })
        @weibo_user = JSON.parse(response.body)
      end
    end
  end
end
