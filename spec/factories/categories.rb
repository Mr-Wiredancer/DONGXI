FactoryGirl.define do
  factory :category do
    sequence(:name){ |n| "category#{n}" }
    sequence(:description){ |n| "description#{n}" }
  end
end
