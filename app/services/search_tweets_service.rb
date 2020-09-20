class SearchTweetsService
  private_class_method :new

  # NOTE: Episode#import_associate_tweetsから実行されること想定
  # NOTE: ここで使用するmax_tweet_idは自力で取ってくることとします
  #       (時間指定でツイートを取得できなかったため)
  #       検索例『#rezero until:2020-09-09_23:59:59_JST』
  #       検索例『#rezero until:2020-09-10_00:00:00_JST』
  #       https://twitter.com/millef_168/status/1293562877488427009
  #       id=>1293562877488427009
  def self.call(hashtag, max_tweet_id, air_time_min)
    new.call(hashtag, max_tweet_id, air_time_min)
  end

  def call(hashtag, max_tweet_id, air_time_min)
    hashtag = '#' + hashtag unless hashtag.include?('#')
    twitter = twitter_rest_client

    fetched_tweets = fetch_tweets_at_anime_broadcast(twitter, hashtag, max_tweet_id, air_time_min)
    extract_tweets(fetched_tweets, air_time_min)
  end

  private

  def twitter_rest_client
    Twitter::REST::Client.new do |config|
      config.consumer_key        = Settings.dig(:twitter, :consumer_key)
      config.consumer_secret     = Settings.dig(:twitter, :consumer_secret)
    end
  end

  # TODO: 原因不明だが、たまに画像を取得できないツイートがあることを確認済み
  # 　　　ほとんどは取得できているので、後で確認
  def fetch_tweets_at_anime_broadcast(twitter, hashtag, max_tweet_id, air_time_min)
    fetch_tweets = []
    fetch_tweets.concat(twitter.search(hashtag, max_id: max_tweet_id).attrs[:statuses])

    while calculate_diff_tweeted_sec(fetch_tweets) < (air_time_min * 60)
      fetch_tweets.concat(twitter.search(hashtag, max_id: fetch_tweets.last[:id] - 1).attrs[:statuses])
    end

    fetch_tweets.reverse!
  end

  def calculate_diff_tweeted_sec(fetch_tweets)
    (Time.parse(fetch_tweets.first[:created_at]) - Time.parse(fetch_tweets.last[:created_at])).abs
  end

  def extract_tweets(fetched_tweets, air_time_min)
    reference_time = DateTime.parse(fetched_tweets.last[:created_at]) - Rational(air_time_min, 24 * 60)
    extracted_tweets = []
    fetched_tweets.each do |tweet|
      extracted_tweets << tweet if reference_time < DateTime.parse(tweet[:created_at])
    end
    extracted_tweets
  end
end
