class Episode < ApplicationRecord
  belongs_to :anime
  has_many :tweets
  validates :anime_id, presence: true
  validates :num, presence: true, uniqueness: { scope: :anime_id, case_sensitive: false }
  validates :active, inclusion: [true, false]

  def import_tweets(max_tweet_id)
    # hashtagは親から取得
    # air_time_minは親から取得
    
    # TwitterSearchService.fetch_tweets
  end
end
