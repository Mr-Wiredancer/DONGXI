FactoryGirl.define do
  factory :project_owner do
    sequence(:name){ |n| "dxhacker-#{n}"}
    introduction  "dxhackers"
    website_url   "http://dxhackers.com"
    id_card_num   "440000000000000000"
  end
end
