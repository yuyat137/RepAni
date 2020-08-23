FactoryBot.define do
  factory :episode do
    anime
    sequence(:num) { |n| n }
    sequence(:subtitle) { |n| "サブタイトル#{n}" }
    sequence(:broadcast_datetime) { DateTime.now -1 }
    exceptional_air_time { nil }
    active { true }
  end
end
