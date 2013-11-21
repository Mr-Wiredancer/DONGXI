FactoryGirl.define do
  factory :project do
    association :user
    association :category
    association :region

    trait :valid do
      association :basic_info, factory: :project_basic_info
      association :story, factory: :project_story
      association :owner, factory: :project_owner
    end
  end
end
