class Episode < ApplicationRecord
  belongs_to :anime
  has_many :tweets
  validates :anime_id, presence: true
  validates :num, presence: true, uniqueness: { scope: :anime_id, case_sensitive: false }
  validates :air_time, presence: true
  validates :active, inclusion: [true, false]

  def import_associate_tweets(max_tweet_id)
    fetched_tweets = SearchTweetsService.call(anime.twitter_hash_tag, max_tweet_id, air_time)
    return unless broadcast_datetime

    Tweet.import_tweets(fetched_tweets, broadcast_datetime, id)
  end
end
