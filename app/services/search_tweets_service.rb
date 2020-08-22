class SearchTweetsService
  private_class_method :new

  # NOTE: Episode#import_associate_tweetsから実行されること想定
  # NOTE: ここで使用するmax_tweet_idは自力で取ってくることとします
  #       検索例『#rezero until:2020-08-12_23:59:59_JST』
  #       https://twitter.com/millef_168/status/1293562877488427009
  #       id=>1293562877488427009
  def self.fetch_tweets(hashtag, max_tweet_id, air_time_min)
    new.fetch_tweets(hashtag, max_tweet_id, air_time_min)
  end

  def fetch_tweets(hashtag, max_tweet_id, air_time_min)
    hashtag = '#' + hashtag unless hashtag.include?('#')
    twitter = twitter_rest_client

    fetch_tweets_at_anime_broadcast(twitter, hashtag, max_tweet_id, air_time_min)
  end

  private

  def twitter_rest_client
    Twitter::REST::Client.new do |config|
      config.consumer_key        = Settings.dig(:twitter, :consumer_key)
      config.consumer_secret     = Settings.dig(:twitter, :consumer_secret)
    end
  end

  def fetch_tweets_at_anime_broadcast(twitter, hashtag, max_tweet_id, air_time_min)
    fetch_tweets = []
    fetch_tweets.concat(twitter.search(hashtag, max_id: max_tweet_id).attrs[:statuses])

    while calculate_diff_tweeted_sec(fetch_tweets) < (air_time_min * 60)
      fetch_tweets.concat(twitter.search(hashtag, max_id: fetch_tweets.last[:id]).attrs[:statuses])
    end

    fetch_tweets
  end

  def calculate_diff_tweeted_sec(fetch_tweets)
    (Time.parse(fetch_tweets.first[:created_at]) - Time.parse(fetch_tweets.last[:created_at])).abs
  end
end
