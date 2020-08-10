class Term < ApplicationRecord
  before_validation :set_season_ja
  has_many :anime_terms
  has_many :animes, through: :anime_terms
  validates :year, presence: true
  validates :season, presence: true, uniqueness: { scope: :year, case_sensitive: false }
  validates :season_ja, presence: true
  # NOTE: vue.js側に値を送る際、"winter"など文字列になるので、vue.js側では統一して文字列を使用する
  enum season: { winter: 1, spring: 2, summer: 3, autumn: 4 }

  def self.get(year = nil, season = nil)
    year ||= Date.today.year
    season ||= (Date.today.month - 1) / 3 + 1
    now_term = Term.find_by(year: year, season: season)
    now_term ||= Term.create(year: year, season: season)
    now_term
  end

  private

  def set_season_ja
    case season
    when 'winter'
      season_ja = '冬'
    when 'spring'
      season_ja = '春'
    when 'summer'
      season_ja = '夏'
    when 'autumn'
      season_ja = '秋'
    end
    self.season_ja = season_ja
  end
end
