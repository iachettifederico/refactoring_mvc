FactoryGirl.define do
  factory :show do
    sequence(:title)  { |n| "Show #{n}" }
    sequence(:domain) { |n| "show#{n}.com" }
  end
end
