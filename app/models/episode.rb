class Episode < ApplicationRecord
  belongs_to :anime
  has_many :tweets
  validates :anime_id, presence: true
  validates :num, presence: true, uniqueness: { scope: :anime_id, case_sensitive: false }
  validates :active, inclusion: [true, false]
end
