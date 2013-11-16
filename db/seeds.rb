# encoding: utf-8
Project.delete_all
#ProjectBasicInfo.delete_all
#ProjectStory.delete_all
#ProjectOwner.delete_all
Category.delete_all
Sponsor.delete_all
Region.delete_all
User.delete_all
Authorization.delete_all
WeiboStatus.delete_all

def project_attr(username = 'admin')
  {
    category_id:    Category.first.id,
    sponsor_id:     Sponsor.first.id,
    user_id:        User.find_by_name(username).id,
    region_id:      Region.first.id
  }
end

def user_attr(username = 'admin')
  {
    name:                   username,
    email:                  "#{username}@dxhackers.com",
    password:               "dxhackers",
    password_confirmation:  "dxhackers"
  }
end

%w(admin hacker).each { |name| User.create(user_attr(name)) }
%w(公益).each { |cat_name| Category.create(name: cat_name, description: "#{cat_name}的描述") }
%w(广州 上海 北京).each { |name| Region.create(name: name, description: name) }
%w(耐克 阿迪达斯 宝洁).each { |sponsor_name| Sponsor.create(name: sponsor_name, description: "#{sponsor_name}的描述") }

# TODO: Create two projects: one for admin, the other for member

project1 = Project.create(project_attr)
project1.build_basic_info(name: "DongXi Tech")
project1.build_story(introduction: "DONGXI TECH 由来自Berkeley的Jiahao Li，圣三一学院的Water，和来自Sun Yat-sen Univ的Allen Wu倾情打造（说的很高端似的……）\n我们主要的想法就是做一个东西。\n 暂时是这个。", weibo_url: "http://weibo.com/3876426391/AiFnt8zMh")
project1.save!

project2 = Project.create(project_attr('hacker'))
project2.build_basic_info(name: "Test Proj")
project2.build_story(introduction: "This is a testing project")
project2.save!
