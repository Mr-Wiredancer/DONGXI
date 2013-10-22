# coding: utf-8
class User < ActiveRecord::Base
  module OmniauthCallbacks
    define_method "find_or_create_for_weibo" do |response|
      uid = response["uid"].to_s
      data = response["info"]

      if user = Authorization.find_by_provider_and_uid('weibo', uid).try(:user)
        user
      else
        user = User.new_from_provider_data('weibo', uid, data)
        if user.save(:validate => false)
          user.authorizations << Authorization.new(provider: 'weibo', uid: uid)
          return user
        else
          Rails.logger.warn("User.create_from_hash 失败, #{user.errors.inspect}")
          return nil
        end
      end
    end

    def new_from_provider_data(provider, uid, data)
      # NOTICE: some unused info list here: location image description nickname urls{blog, weibo}
      User.new do |user|
        if data["email"].present? && !User.where(email: data["email"]).exists?
          user.email = data["email"]
        else
          user.email = "#{provider}+#{uid}@dongxi.com"
        end
        user.name = data["name"]
        user.password = Devise.friendly_token[0, 20]
      end
    end
  end
end
