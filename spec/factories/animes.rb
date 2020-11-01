FactoryBot.define do
  factory :anime do
    sequence(:title) { |n| "title_#{n}" }
    public_url { 'http://example.com' }
    default_air_time { 30 }
    sequence(:twitter_account) { |n| "test_screen_name_#{n}" }
    sequence(:twitter_hash_tag) { |n| "test_hash_tag_#{n}" }
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
