class ImportTweetsService
  private_class_method :new

  def self.call(episode_id, max_tweet_id)
    new.call(episode_id, max_tweet_id)
  end

  def call(episode_id, max_tweet_id)
    @episode = Episode.find(episode_id)
    @hashtag = "##{@episode.anime.twitter_hash_tag}"
    @twitter = TwitterRestClientService.call
    return unless @episode&.broadcast_datetime

    fetch_and_import_all_tweets(max_tweet_id)
  end

  private

  def fetch_and_import_all_tweets(max_tweet_id)
    loop do
      last_tweet = fetch_and_import_tweets(max_tweet_id)
      return if last_tweet.nil?

      max_tweet_id = last_tweet[:id] - 1

      break if import_all?(last_tweet[:created_at])
    end
  end

  def fetch_and_import_tweets(tweet_id)
    fetch_tweets = @twitter.search(@hashtag, max_id: tweet_id).attrs[:statuses]
    return if fetch_tweets.blank?

    last_tweet = fetch_tweets.last
    # ツイートを時間で抽出
    in_time_tweets = return_in_time(fetch_tweets)
    # ツイートの型を変換
    new_tweets = Tweet.convert_from_json(in_time_tweets, @episode.broadcast_datetime, @episode.id)
    Tweet.import new_tweets

    fetch_tweets.last
  end

  def import_all?(tweeted_at)
    calculate_diff_sec(tweeted_at, @episode.broadcast_datetime) < 0
  end

  def calculate_diff_sec(subtrahend_datetime, minuend_datetime)
    Time.parse(subtrahend_datetime.to_s) - Time.parse(minuend_datetime.to_s)
  end

  def return_in_time(tweets)
    start_time = @episode.broadcast_datetime
    in_time_tweets = []
    tweets.each do |tweet|
      in_time_tweets << tweet if start_time <= DateTime.parse(tweet[:created_at])
    end
    in_time_tweets
  end
end
