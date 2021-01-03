class FetchTweetsService
  private_class_method :new
  GET_TWEETS_NUM = 300

  def self.call(episode_id, over_tweet_id, progress_time_msec)
    new.call(episode_id, over_tweet_id, progress_time_msec)
  end

  def call(episode_id, over_tweet_id, progress_time_msec)
    episode = Episode.find(episode_id.to_i)

    if !over_tweet_id.blank?
      episode.tweets.where(tweet_id: Range.new(over_tweet_id.to_i + 1, nil)).order(:tweet_id).limit(GET_TWEETS_NUM)
    elsif !progress_time_msec.blank?
      episode.tweets.where(progress_time_msec: Range.new(progress_time_msec, nil)).order(:tweet_id).limit(GET_TWEETS_NUM)
    end
  end
end
