FactoryBot.define do
  factory :tweet do
    episode
    sequence(:tweet_id) { |n| n }
    sequence(:serial_number) { |n| n }
    sequence(:progress_time_msec) { serial_number * 1000 }
    sequence(:name) { |n| "test#{n}_name" }
    sequence(:screen_name) { |n| "test#{n}_screen_name" }
    sequence(:profile_image_url) { "https://placeimg.com/48/48/nature" }
    sequence(:text) { |n| "test#{n}_text" }
    sequence(:tweeted_at) { |n| DateTime.now - n }
  end
end
