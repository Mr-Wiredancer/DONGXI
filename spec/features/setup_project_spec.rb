# coding: utf-8
require 'spec_helper'

feature "Setup Project" do
	background do 
		User.create(name: "user", email: "user@vmengxiang.com", password: "vmengxiang", password_confirmation: "vmengxiang")
		User.create(name: "admin", email: "admin@dxhackers.com", password: "dxhackers", password_confirmation: "dxhackers")
		Category.create(name: "公益", description: "公益项目包括扶助弱势群体,提供就业机会等等")
		Region.create(name: "广州", description: "广州是一座美丽的城市,主要都是吃的")
	end

	scenario "create a project on straight flow" do
		log_in_with(email: "user@vmengxiang.com", password: "vmengxiang")
		click_link "一个新项目"

		# edit project
	  attach_file "项目图片", "#{Rails.root}/spec/mock/project.png"
	  fill_in "项目名称", with: "Testing Project"
	  fill_in "宣传语", with: "我们这个项目给力啊"
	  select "公益", from: "分类"
	  select "广州", from: "项目地区"
    fill_in "天数", with: 30
    select "金钱", from: "募集类型"
    fill_in "project_basic_info_attributes_amount", with: 1000 # add amount

	  click_button "保存"
	  expect(page).to have_content("这不仅仅是一个项目")	
    
    fill_in "项目视频", with: "<iframe height=596 width=620 src='http://player.youku.com/embed/XMzk1NjM4MzMy' frameborder=0 allowfullscreen></iframe>"
    fill_in "微博地址", with: "http://weibo.com/3876426391/AiFnt8zMh"
    fill_in "项目介绍", with: "反正就是一个给力的项目，详情暂时不说为好" 
    fill_in "风险与挑战", with: "一点风险都没有"
    click_button "保存"
    expect(page).to have_content("现在让我们来认识一下你")

    attach_file "个人照片", "#{Rails.root}/spec/mock/avatar.jpg"
    fill_in "姓名", with: "V梦享"
    fill_in "身份证", with: "330112199010100203"
    fill_in "个人介绍", with: "我是V梦享，我有大梦想！"
    fill_in "个人网页", with: "http://dxhackers.com"
    click_button "保存"
    expect(page).to have_content("提交你的项目吧")

    # submit project
    click_link "提交审核"
    expect(page).to have_content("项目预览")
    expect(page).to have_content("提交成功!等待审核中...")
	end
	
end  
