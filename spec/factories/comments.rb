# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :comment do
    association :project
    association :user
    sequence(:body){ |n| "Comment-#{n}" }
  end
end
