FactoryBot.define do
  factory :anime do
    sequence(:title) { |n| "test#{n}_title" }
    public_url { 'http://example.com' }
    default_air_time { 30 }
    sequence(:twitter_account) { |n| "test#{n}_screen_name" }
    sequence(:twitter_hash_tag) { |n| "test#{n}_hash_tag" }
    public { true }
  end
  trait :associate_term do
    after(:create) do |anime|
      term = create(:term)
      create(:anime_term, anime_id: anime.id, term_id: term.id)
    end
  end
  trait :associate_now_term do
    after(:create) do |anime|
      term = create(:term, :now_true)
      create(:anime_term, anime_id: anime.id, term_id: term.id)
    end
  end
  trait :associate_all do
    after(:create) do |anime|
      term = create(:term)
      create(:anime_term, anime_id: anime.id, term_id: term.id)
      create(:episode, :with_tweets, anime_id: anime.id)
    end
  end
  trait :public do
    after(:create) do |anime|
      anime.update(public: true)
    end
  end
  trait :private do
    after(:create) do |anime|
      anime.update(public: false)
    end
  end
  trait :episodes do
    after(:create) do |anime|
      create_list(:episode, 12, anime_id: anime.id)
    end
  end
end
