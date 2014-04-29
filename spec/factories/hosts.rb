FactoryGirl.define do
  factory :host do
    sequence(:name)  { |n| "Host #{n}" }
    sequence(:email)  { |n| "host#{n}@example.com" }
  end
end
