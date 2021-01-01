class ImportTweetsService
  private_class_method :new
  IMPORT_TWEETS_NUM = 1000

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
    count = 0
    new_tweets = []

    # ツイート取得
    fetch_tweets = @twitter.search(@hashtag, max_id: max_tweet_id).attrs[:statuses]
    count += 100
    last_tweet = fetch_tweets.last
    # ツイートを時間で抽出
    fetch_tweets = extract_tweets(fetch_tweets)
    # ツイートの型を変換
    fetch_tweets = Tweet.convert_from_json(fetch_tweets, @episode.broadcast_datetime, @episode.id)
    # ツイートを結合
    new_tweets.concat(fetch_tweets)

    while calculate_diff_tweeted_sec(last_tweet) > 0
      # ツイート取得
      fetch_tweets = @twitter.search(@hashtag, max_id: last_tweet[:id] - 1).attrs[:statuses]
      count += 100
      last_tweet = fetch_tweets.last
      # ツイートを時間で抽出
      fetch_tweets = extract_tweets(fetch_tweets)
      # ツイートの型を変換
      fetch_tweets = Tweet.convert_from_json(fetch_tweets, @episode.broadcast_datetime, @episode.id)
      # ツイートを結合
      new_tweets.concat(fetch_tweets)

      if count > IMPORT_TWEETS_NUM
        Tweet.import new_tweets
        count = 0
        new_tweets = []
      end
    end
  end

  # ここのメソッド名後で変更
  def calculate_diff_tweeted_sec(tweet)
    # ここのto_sは後で変えたい
    Time.parse(tweet[:created_at].to_s) - Time.parse(@episode.broadcast_datetime.to_s)
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
