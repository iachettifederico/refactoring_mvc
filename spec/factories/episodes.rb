FactoryGirl.define do
  factory :episode do
    sequence(:title) { |n| "Episode t#{n}" }
  end
end
