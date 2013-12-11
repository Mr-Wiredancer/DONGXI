# coding: utf-8
require 'spec_helper'

feature "Sign up and login" do
	background do 
		User.create(name: "user", email: "user@vmengxiang.com", password: "vmengxiang", password_confirmation: "vmengxiang")
	end
	
	scenario "Sign up with correct credentials" do
		visit '/'
		click_link '注册'
	  fill_in '姓名', with: 'allen'
	  fill_in '邮箱', with: 'allen@dxhackers.com'
	  fill_in '密码', with: 'dxhackers'
	  fill_in '确认密码', with: 'dxhackers'
	  click_button '注册'
	  expect(page).to have_content("您的帐号已注册成功！")
	  #save_and_open_page  ## before uncomment this debug line you should install the gem 'launchy'
	end
	scenario "Log in with correct credentials" do
		log_in_with(email: "user@vmengxiang.com", password: "vmengxiang")
		expect(page).to have_content("登录成功")
	end

  scenario "Log in with incorrect credentials" do
  	log_in_with(email: "user@vmengxiang.com", password: "vmeng")
  	expect(page).to have_content("帐号或密码错误")
  end

  scenario "Log out" do
  	log_in_with(email: "user@vmengxiang.com", password: "vmengxiang")
  	log_out
  	expect(page).to have_content("退出成功")
  end

end