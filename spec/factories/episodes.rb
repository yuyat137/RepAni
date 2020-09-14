FactoryBot.define do
  factory :episode do
    anime
    sequence(:num) { |n| n }
    sequence(:subtitle) { |n| "サブタイトル#{n}" }
    sequence(:broadcast_datetime) { DateTime.now -1 }
    air_time { 30 }
    active { true }
  end
end
