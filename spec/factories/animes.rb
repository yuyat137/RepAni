FactoryBot.define do
  factory :anime do
    sequence(:title) { |n| "title_#{n}" }
    public_url { 'http://example.com' }
    default_air_time { 30 }
    sequence(:twitter_account) { |n| "test_screen_name_#{n}" }
    sequence(:twitter_hash_tag) { |n| "test_hash_tag_#{n}" }
    state { :open }
  end
  trait :associate_term do
    after(:create) do |anime|
      term = create(:term)
      create(:anime_term, anime_id: anime.id, term_id: term.id)
    end
  end
end
