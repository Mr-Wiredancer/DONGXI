FactoryGirl.define do
  factory :user do
    sequence(:name){ |n| "name#{n}" }
    sequence(:email){ |n| "user#{n}@dxhackers.com" }
    password "password"
    password_confirmation "password"

    trait :admin do
      name "admin"
      email "admin@dxhackers.com"
    end
  end

end
