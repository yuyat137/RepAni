class Episode < ApplicationRecord
  belongs_to :anime
  has_many :tweets
  validates :anime_id, presence: true
  validates :num, presence: true, uniqueness: { scope: :anime_id, case_sensitive: false }
  validates :active, inclusion: [true, false]

  def import_associate_tweets(max_tweet_id)
    fetched_tweets = SearchTweetsService.fetch_tweets(anime.twitter_hash_tag, max_tweet_id, air_time)
    Tweet.import_tweets(fetched_tweets, id)
  end

  private

  def air_time
    exceptional_air_time || anime.default_air_time
  end
end
