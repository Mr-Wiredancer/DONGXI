class ProjectStory < ActiveRecord::Base
  attr_accessible :introduction, :risk, :video_url, :weibo_url

  belongs_to :project

  with_options if: lambda { |o| o.in_submit? } do |condition|
    condition.validates :introduction, presence: true
    condition.validates :risk, presence: true
    condition.validates :video_url, presence: true#, format: { with: /([http|https]:\/\/)?[a-zA-Z0-9]+(\.[a-zA-Z0-9]+)+/ }
    # http://weibo.com/{user_id}/{status_mid} TODO: status_mid always has 9 digits?
    condition.validates :weibo_url, presence: true, format: { with: /http:\/\/weibo\.com\/\d{10}\/[0-9A-Za-z]{9}/ }
  end

  after_save :save_weibo_id, if: lambda { |story| story.has_valid_weibo? }

  def save_weibo_id
    mid = self.weibo_url.split('/').last

    begin
      client = OAuth2::Client.new(ENV["WEIBO_APPKEY"], ENV["WEIBO_APPSECRET"], :site => 'http://api.weibo.com')
      response = client.request(:get, "https://api.weibo.com/2/statuses/queryid.json", :params => { mid: mid, type: 1, isBase62: 1, access_token: ENV["WEIBO_ACCESS_TOKEN"] })
      id = JSON.parse(response.body)["id"]

      weibo = self.project.weibo_status || WeiboStatus.create(project_id: self.project_id)
      weibo.update_attributes!(status_mid: mid, status_id: id)
    rescue => e
      nil # what can we do ?
    end
  end

  def in_submit?
    project && project.in_submit?
  end

  def has_valid_weibo?
    return false if self.weibo_url.nil?
    !!(self.weibo_url =~ /http:\/\/weibo\.com\/\d{10}\/[0-9A-Za-z]{9}/)
  end
end
