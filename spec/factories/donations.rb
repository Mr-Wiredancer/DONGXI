FactoryGirl.define do
  factory :donation do
    association :donor, factory: :user
    association :project
    trade_no "2013112000001000000072962895"
    amount 1
  end
end
