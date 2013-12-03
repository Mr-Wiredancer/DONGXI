# coding: utf-8
module Features
	module SessionHelpers
		# Credit to Thoughtbot: http://robots.thoughtbot.com/rspec-integration-tests-with-capybara/
		def log_in_with(options = {})
			default_options = { email: "foo@bar.com", password: "foobar" }
			options = default_options.merge(options)
			visit new_user_session_path
			fill_in '邮箱',	with: options[:email]
			fill_in '密码', 	with: options[:password]
		  click_button '登录'	
		end
		def log_out
			click_on '退出登录'
		end
	end
end