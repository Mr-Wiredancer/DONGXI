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
Donation.delete_all

def project_attr(username = 'admin')
  {
    category_id:    Category.first.id,
    sponsor_id:     Sponsor.first.id,
    user_id:        User.find_by_name(username).id,
    region_id:      Region.first.id
  }
end

def project_basic_info_attr
  {
    name: 'DongXi Tech',
    slogan: 'DongXi Tech Rocks!',
    amount: 1000,
    duration_days: 30,
    raise_type: 1,
  }
end

def project_story_attr
  {
    introduction: "DONGXI TECH 由来自Berkeley的Jiahao Li，圣三一学院的Water，和来自Sun Yat-sen Univ的Allen Wu倾情打造（说的很高端似的……）\n我们主要的想法就是做一个东西。\n 暂时是这个。",
    weibo_url: "http://weibo.com/3876426391/AiFnt8zMh",
    video_url: '<iframe height=596 width=620 src="http://player.youku.com/embed/XMzk1NjM4MzMy" frameborder=0 allowfullscreen></iframe>',
    risk: "Risk Risk Risk",
  }
end

def project_owner_attr
  {
    name: 'dxhacker',
    introduction: '我们是dxhackers!',
    website_url: 'http://dxhackers.com',
    id_card_num: '440000000000000000',
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

project1 = Project.create(project_attr)
project1.build_basic_info(project_basic_info_attr)
project1.build_story(project_story_attr)
project1.build_owner(project_owner_attr)
project1.save!
project1.submit!
project1.publish!

project2 = Project.create(project_attr)
project2.build_basic_info(name: "Test Proj")
project2.build_story(introduction: "This is a testing project")
project2.save!

project3 = Project.create(project_attr('hacker'))
project3.build_basic_info(name: "Test Proj 2")
project3.build_story(introduction: "This is a testing project")
project3.save!
