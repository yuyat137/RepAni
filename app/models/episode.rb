class Episode < ApplicationRecord
  before_validation :set_public
  belongs_to :anime
  has_many :tweets, dependent: :destroy
  validates :anime_id, presence: true
  validates :num, presence: true, uniqueness: { scope: :anime_id, case_sensitive: false }
  validates :broadcast_datetime, presence: true
  validates :air_time, presence: true
  validates :public, inclusion: [true, false]

  # 
  def import_associate_tweets(max_tweet_id)
    return unless broadcast_datetime

    json_tweets = SearchTweetsService.call(anime.twitter_hash_tag, max_tweet_id, air_time)
    new_tweets = Tweet.convert_from_json(json_tweets, broadcast_datetime, id)
    new_tweets.each_slice(3000) do |tweets|
      Tweet.import tweets
    end
  end

  def anime_title
    anime.title
  end

  private

  def set_public
    self.public = false if public.nil?
  end
end
