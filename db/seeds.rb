# encoding: utf-8
Project.delete_all
ProjectBasicInfo.delete_all
ProjectStory.delete_all
Category.delete_all
Sponsor.delete_all
Region.delete_all
User.delete_all
Authorization.delete_all

%w(慈善 体育 艺术).each do |cat_name|
  Category.create(name: cat_name, description: "#{cat_name}的描述")
end

%w(耐克 阿迪达斯 宝洁).each do |sponsor_name|
  Sponsor.create(name: sponsor_name, description: "#{sponsor_name}的描述")
end

project = Project.new(category_id: Category.first.id, sponsor_id: Sponsor.first.id)
project.basic_info = ProjectBasicInfo.create(name: "DongXi Tech")
project.story = ProjectStory.create(introduction: "DONGXI TECH 由来自Berkeley的Jiahao Li，圣三一学院的Water，和来自Sun Yat-sen Univ的Allen Wu倾情打造（说的很高端似的……）\n我们主要的想法就是做一个东西。\n 暂时是这个。")
project.save

%w(广州 上海 北京).each do |name|
  Region.create(name: name, description: name)
end
