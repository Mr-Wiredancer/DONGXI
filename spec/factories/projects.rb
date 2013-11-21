FactoryGirl.define do
  factory :project do
    association :user

    #trait :audit do
      #status 1
    #end

    #after(:build) { |user| user.class.skip_callback(:validation) }
  end
end
