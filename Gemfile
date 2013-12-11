# coding: utf-8
source 'http://ruby.taobao.org' #rubygems mirror. check ruby.taobao.org

gem 'rails', '3.2.14'
gem 'sass-rails',   '~> 3.2.3'
gem 'coffee-rails', '~> 3.2.1'
gem 'uglifier', '>= 1.0.3'
gem 'turbo-sprockets-rails3'
gem 'jquery-rails'

gem 'ckeditor', :git => "git://github.com/allenfantasy/ckeditor.git"

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
gem 'omniauth-renren-oauth2'

# 图片上传
gem 'paperclip', '~> 3.0'

group :development do
  gem 'binding_of_caller', :platform => [:mri_19, :rbx]
  gem 'better_errors'
end

group :development, :test do
  gem 'factory_girl_rails'
  gem 'rspec-rails'
  gem 'pry-rails'
  gem 'database_cleaner'
  gem 'fuubar'
  gem 'capistrano', '~> 2.15'
  gem 'rvm-capistrano'
  gem 'spork', '~> 1.0rc'
end
group :test do
  gem 'capybara'
end

group :production do
  gem 'rails_12factor'
	gem 'unicorn'
end

ruby '1.9.3'
