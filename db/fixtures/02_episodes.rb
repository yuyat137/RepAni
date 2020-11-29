12.times do |n|
  Episode.seed(:id, {
    anime: Anime.find_by(title: 'テストアニメ'),
    num: n + 1,
    subtitle: Faker::JapaneseMedia::SwordArtOnline.game_name,
    broadcast_datetime: DateTime.now - (7 * 12).day + (n * 7).day,
    air_time: Faker::Number.number(digits: 2),
    public: true
  })
end
