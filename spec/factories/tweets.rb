FactoryBot.define do
  factory :tweet do
    episode
    sequence(:tweet_id) { |n| n }
    sequence(:name) { |n| "test_name#{n}" }
    sequence(:screen_name) { |n| "test_screen_name#{n}" }
    sequence(:text) { |n| "test_text#{n}" }
    sequence(:tweeted_at) { |n| DateTime.now - n }
  end
end
