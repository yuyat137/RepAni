class FetchTweetsByProgressTimeService
  private_class_method :new
  GET_TWEETS_NUM = 300

  def self.call(episode_id, progress_time_msec)
    new.fetch_tweets(episode_id, progress_time_msec)
  end

  def fetch_tweets(episode_id, progress_time_msec)
    episode = Episode.find(episode_id)
    serial_number = episode.tweets.find_by(progress_time_msec: Range.new(progress_time_msec, nil)).serial_number
    tweets = episode.tweets.limit(GET_TWEETS_NUM).offset(serial_number)
  end
end
