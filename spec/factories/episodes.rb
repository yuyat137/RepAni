FactoryBot.define do
  factory :episode do
    anime
    sequence(:num) { |n| n }
    sequence(:subtitle) { |n| "test#{n}_subtitle" }
    sequence(:broadcast_datetime) { DateTime.now - 1.day }
    air_time { 30 }
    public { true }
  end
  trait :with_tweets do
    after(:create) do |episode|
      200.times do |n|
        create(:tweet, episode_id: episode.id, progress_time_msec: n * 1000, tweeted_at: episode.broadcast_datetime.advance(seconds: n) )
      end
    end
  end
end
