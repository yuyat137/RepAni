class Tweet < ApplicationRecord
  belongs_to :episode
  validates :episode_id, presence: true
  validates :tweet_id, presence: true, uniqueness: true
  validates :name, presence: true
  validates :screen_name, presence: true
  validates :text, presence: true
  validates :tweeted_at, presence: true

  def self.import_tweets(tweets, episode_id)
    new_tweets = []
    tweets.each do |tweet|
      next unless tweet[:retweeted_status].nil? && tweet.dig(:user, :protected) == false && tweet[:in_reply_to_user_id].nil?

      new_tweets << {
        episode_id: episode_id,
        tweet_id: tweet[:id],
        name: tweet.dig(:user, :name),
        screen_name: tweet.dig(:user, :screen_name),
        text: tweet[:text],
        image_url1: tweet.dig(:extended_entities, :media, 0, :media_url_https),
        image_url2: tweet.dig(:extended_entities, :media, 1, :media_url_https),
        image_url3: tweet.dig(:extended_entities, :media, 2, :media_url_https),
        image_url4: tweet.dig(:extended_entities, :media, 3, :media_url_https),
        tweeted_at: tweet[:created_at].in_time_zone('Tokyo'),
        created_at: Time.zone.now,
        updated_at: Time.zone.now
      }
    end
    Tweet.insert_all(new_tweets)
  end
end
