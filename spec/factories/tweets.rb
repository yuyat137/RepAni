FactoryBot.define do
  factory :tweet do
    episode
    sequence(:tweet_id) { |n| n }
    sequence(:serial_number) { |n| n }
    sequence(:progress_time_msec) { serial_number * 1000 }
    sequence(:name) { |n| "test_name#{n}" }
    sequence(:screen_name) { |n| "test_screen_name#{n}" }
    sequence(:profile_image_url) { "https://placeimg.com/48/48/nature" }
    sequence(:text) { |n| "test_text#{n}" }
    sequence(:tweeted_at) { |n| DateTime.now - n }
  end
end
