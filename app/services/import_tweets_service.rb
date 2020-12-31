class ImportTweetsService
  private_class_method :new

  # 一旦、このサービスクラスにまとめて書く。成功すれば分けて書くことも考える
  def self.call(episode_id, max_tweet_id)
    new.call(episode_id, max_tweet_id)
  end

  def call(episode_id, max_tweet_id)
    @episode = Episode.find(episode_id)
    hashtag = @episode.anime.twitter_hash_tag
    # 一旦このまま、↓ここのロジックおかしい
    @hashtag = "##{hashtag unless hashtag.include?('#')}"
    @twitter = TwitterRestClientService.call
    return unless @episode&.broadcast_datetime

    fetch_tweets_at_anime_broadcast(max_tweet_id)
  end

  private

  # TODO: 原因不明だが、たまに画像を取得できないツイートがあることを確認済み
  def fetch_tweets_at_anime_broadcast(max_tweet_id)
    fetch_tweets = @twitter.search(@hashtag, max_id: max_tweet_id).attrs[:statuses]
    fetch_tweets = extract_tweets(fetch_tweets)
    fetch_tweets = Tweet.convert_from_json(fetch_tweets, @episode.broadcast_datetime, @episode.id)
    last_tweet = fetch_tweets.last
    Tweet.import fetch_tweets

    while calculate_diff_tweeted_sec(last_tweet) < (@episode.air_time * 60)
      fetch_tweets = @twitter.search(@hashtag, max_id: fetch_tweets.last[:tweet_id] - 1).attrs[:statuses]
      fetch_tweets = extract_tweets(fetch_tweets)
      fetch_tweets = Tweet.convert_from_json(fetch_tweets, @episode.broadcast_datetime, @episode.id)
      last_tweet = fetch_tweets.last
      Tweet.import fetch_tweets
    end

  end

  def calculate_diff_tweeted_sec(tweet)
    # ここにtweetが渡らないことがある
    # ここのto_sは後で変えたい
    (Time.parse(tweet[:tweeted_at].to_s) - Time.parse(@episode.broadcast_datetime.to_s)).abs
  end

  # 時間内のツイートのみ返す
  def extract_tweets(fetched_tweets)
    start_time = @episode.broadcast_datetime
    extracted_tweets = []
    fetched_tweets.each do |tweet|
      extracted_tweets << tweet if start_time < DateTime.parse(tweet[:created_at])
    end
    extracted_tweets
  end
end
