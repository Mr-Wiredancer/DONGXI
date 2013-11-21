FactoryGirl.define do
  factory :project_basic_info do
    sequence(:name){ |n| "project-name#{n}" }
    sequence(:slogan){ |n| "slogan#{n}" }
    amount 1000
    duration_days 30
    raise_type 1
  end
end
