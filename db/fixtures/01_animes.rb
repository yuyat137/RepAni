Anime.seed(:id, [
  {
    title: "テストアニメ",
    public_url: Faker::Internet.url,
    default_air_time: Faker::Number.number(digits: 2),
    twitter_account: Faker::Twitter.screen_name,
    twitter_hash_tag: 'test',
    public: false
  },
])
