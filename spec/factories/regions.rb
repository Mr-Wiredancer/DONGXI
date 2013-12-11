FactoryGirl.define do
  factory :region do
    sequence(:name){ |n| "region#{n}" }
    sequence(:description){ |n| "description#{n}" }
  end
end
