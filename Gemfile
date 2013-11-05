# coding: utf-8
source 'http://ruby.taobao.org' #rubygems mirror. check ruby.taobao.org

gem 'rails', '3.2.14'
gem 'sass-rails',   '~> 3.2.3'
gem 'coffee-rails', '~> 3.2.1'
gem 'uglifier', '>= 1.0.3'
gem 'jquery-rails'

# databases
gem 'sqlite3', :group => [:development, :test]
gem 'pg', :group => :production

# 用户系统
gem 'devise'
gem 'cancan'

# 系统配置
gem 'figaro'

# 第三方 OAuth 登录
gem 'omniauth'
gem 'omniauth-weibo-oauth2'

# 图片上传
gem 'paperclip', '~> 3.0'

group :development, :test do
  gem 'better_errors'
  gem 'binding_of_caller', :platform => [:mri_19, :rbx]
  #gem 'capybara'
  gem 'rspec-rails'
  gem 'pry-rails'
  gem 'capistrano', '~> 2.15'
  gem 'rvm-capistrano'
end

group :production do
  gem 'rails_12factor'
	gem 'unicorn'
end


# To use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.0.0'

# To use Jbuilder templates for JSON
# gem 'jbuilder'

# Use unicorn as the app server
# gem 'unicorn'

# Deploy with Capistrano
# gem 'capistrano'

# To use debugger
# gem 'debugger'

ruby '1.9.3'
