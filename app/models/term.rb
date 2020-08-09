class Term < ApplicationRecord
  has_many :anime_terms
  has_many :animes, through: :anime_terms
  validates :year, presence: true
  validates :season, presence: true
  enum season: { winter: 1, spring: 2, summer: 3, autumn: 4 }

  def self.now(year = nil, season = nil)
    year ||= Date.today.year
    season ||= (Date.today.month - 1) / 3 + 1
    now_term = Term.find_by(year: year, season: season)
    unless now_term
      now_term = Term.create(year: year, season: season)
    end
    now_term
  end
end
