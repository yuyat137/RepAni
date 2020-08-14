class TwitterSearchService
  private_class_method :new

  # NOTE: ここで使用するmax_tweet_idは自力で取ってくることとします
  #       検索例『#rezero until:2020-08-12_23:59:59_JST』
  #       https://twitter.com/millef_168/status/1293562877488427009
  #       id=>1293562877488427009
  def self.fetch_tweets(hashtag, max_tweet_id, air_time_min)
    new.fetch_tweets(hashtag, max_tweet_id, air_time_min)
  end

  def fetch_tweets(hashtag, max_tweet_id, air_time_min)
    hashtag = '#' + hashtag unless hashtag.include?('#')
    twitter = Twitter::REST::Client.new do |config|
      config.consumer_key        = Settings.dig(:twitter, :consumer_key)
      config.consumer_secret     = Settings.dig(:twitter, :consumer_secret)
    end

    fetched_tweets = []
    fetched_tweets.concat(twitter.search(hashtag, max_id: max_tweet_id).attrs[:statuses])

    while calculate_sub_tweeted_sec(fetched_tweets) < (air_time_min * 60) do
      fetched_tweets.concat(twitter.search(hashtag, max_id: fetched_tweets.last[:id]).attrs[:statuses])
    end
    fetched_tweets
  end

  private

  def calculate_sub_tweeted_sec(fetched_tweets)
    (Time.parse(fetched_tweets.first[:created_at]) - Time.parse(fetched_tweets.last[:created_at])).abs
  end
end
