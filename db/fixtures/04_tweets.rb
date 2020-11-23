anime = Anime.find_by(title: 'テストアニメ')
episode = anime.episodes.first

100.times do |n|
  Tweet.seed(:id, {
    episode: episode,
    tweet_id: Faker::Twitter.status[:id],
    progress_time_msec: (n / 3) * 1000,
    serial_number: n + 1,
    name: Faker::Twitter.user[:name],
    screen_name: Faker::Twitter.user[:screen_name],
    profile_image_url: Faker::Twitter.user[:profile_image_url],
    text: Faker::Twitter.status[:text],
    image_url1: nil,
    image_url2: nil,
    image_url3: nil,
    image_url4: nil,
    tweeted_at: episode.broadcast_datetime + (n / 3)
  })
end
