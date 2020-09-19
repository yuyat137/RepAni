class Tweet < ApplicationRecord
  belongs_to :episode
  validates :episode_id, presence: true
  validates :tweet_id, presence: true, uniqueness: true
  validates :name, presence: true
  validates :screen_name, presence: true
  validates :text, presence: true
  validates :tweeted_at, presence: true
  GET_TWEETS_NUM = 300

  def self.import_tweets(tweets, broadcast_datetime, episode_id)
    new_tweets = []
    serial_number = 1
    tweets.each do |tweet|
      next unless tweet[:retweeted_status].nil? && tweet.dig(:user, :protected) == false && tweet[:in_reply_to_user_id].nil?

      tweeted_at = tweet[:created_at].in_time_zone('Tokyo')
      new_tweets << {
        episode_id: episode_id,
        tweet_id: tweet[:id],
        serial_number: serial_number,
        name: tweet.dig(:user, :name),
        screen_name: tweet.dig(:user, :screen_name),
        text: tweet[:text],
        image_url1: tweet.dig(:extended_entities, :media, 0, :media_url_https),
        image_url2: tweet.dig(:extended_entities, :media, 1, :media_url_https),
        image_url3: tweet.dig(:extended_entities, :media, 2, :media_url_https),
        image_url4: tweet.dig(:extended_entities, :media, 3, :media_url_https),
        tweeted_at: tweeted_at,
        progress_time_msec: (tweeted_at - broadcast_datetime).to_i * 1000,
        created_at: Time.zone.now,
        updated_at: Time.zone.now
      }
      serial_number += 1
    end
    Tweet.insert_all(new_tweets)
  end
end
