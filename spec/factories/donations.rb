FactoryGirl.define do
  factory :donation do
    association :donor, factory: :user
    association :project
    sequence(:trade_no){ |n| "201311200000100000007296289#{n}" }
    amount 1
  end
end
