FactoryBot.define do
  factory :anime do
    sequence(:title) { |n| "test#{n}_title" }
    public_url { 'http://example.com' }
    default_air_time { 30 }
    sequence(:twitter_account) { |n| "test#{n}_screen_name" }
    sequence(:twitter_hash_tag) { |n| "test#{n}_hash_tag" }
    public { true }
    first_broadcast_datetime { DateTime.now - 3.month }
  end
  trait :with_term do
    after(:create) do |anime|
      term = create(:term)
      create(:anime_term, anime_id: anime.id, term_id: term.id)
    end
  end
  trait :with_episodes do
    after(:create) do |anime|
      create_list(:episode, 12, anime_id: anime.id)
    end
  end
  trait :with_now_term do
    after(:create) do |anime|
      term = create(:term, :now_true)
      create(:anime_term, anime_id: anime.id, term_id: term.id)
    end
  end
  trait :with_all do
    after(:create) do |anime|
      term = create(:term)
      create(:anime_term, anime_id: anime.id, term_id: term.id)
      create(:episode, :with_tweets, anime_id: anime.id)
    end
  end
end
