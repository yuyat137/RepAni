class Term < ApplicationRecord
  before_save :set_season_ja
  has_many :anime_terms
  has_many :animes, through: :anime_terms
  validates :year, presence: true
  validates :season, presence: true
  enum season: { winter: 1, spring: 2, summer: 3, autumn: 4 }

  def self.now(year = nil, season = nil)
    year ||= Date.today.year
    season ||= (Date.today.month - 1) / 3 + 1
    now_term = Term.find_by(year: year, season: season)
    now_term ||= Term.create(year: year, season: season)
    now_term
  end

  private

  def set_season_ja
    case season
    when "winter" then
      season_ja = '冬'
    when "spring" then
      season_ja = '春'
    when 'summer' then
      season_ja = '夏'
    when 'autumn' then
      season_ja = '秋'
    end
    self.season_ja = season_ja
  end
end
