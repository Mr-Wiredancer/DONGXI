# coding: utf-8
require 'spec_helper'

feature "Manage Projects" do 
  background do
    # create users
    user = User.create(name: "user", email: "user@vmengxiang.com", password: "vmengxiang", password_confirmation: "vmengxiang")
    User.create(name: "admin", email: "admin@dxhackers.com", password: "dxhackers", password_confirmation: "dxhackers")

    # create a published project
    p = FactoryGirl.create(:project, :valid, user: user)
    p.submit!
  end

  scenario "admin can publish in_audit project" do
    log_in_with(email: "admin@dxhackers.com", password: "dxhackers")

    visit '/cpanel/projects'

    expect(page).to have_content("管理所有项目")
    expect(page).to have_content("审核中") 
    expect(page).to have_selector("#publish") 
    expect(page).to have_selector("#unpublish") 

    click_link "发布"
    expect(page).to have_content("发布成功!") 

  end

  scenario "admin can unpublish in_audit project" do
    log_in_with(email: "admin@dxhackers.com", password: "dxhackers")

    visit '/cpanel/projects'

    click_link "退回编辑"
    expect(page).to have_content("取消发布成功!") 
  end
end