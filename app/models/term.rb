class Term < ApplicationRecord
  before_validation :set_season_ja
  # TODO: set_nowメソッド実装する
  # before_validation :set_now
  has_many :anime_terms
  has_many :animes, through: :anime_terms
  validates :year, presence: true
  validates :season, presence: true, uniqueness: { scope: :year, case_sensitive: false }
  validates :season_ja, presence: true
  validates :now, inclusion: [true, false]
  # NOTE: vue.js側に値を送る際、"winter"など文字列になるので、vue.js側では統一して文字列を使用する
  enum season: { winter: 1, spring: 2, summer: 3, autumn: 4 }

  def self.fetch_now_or_select_term(year = nil, season_num = nil)
    year ||= Date.today.year
    season_num ||= (Date.today.month - 1) / 3 + 1
    Term.find_or_create_by({ year: year.to_i, season: season_num.to_i })
  end

  def self.update_all_now_attribute
    Term.update_all(now: false)
    Term.fetch_now_or_select_term.update(now: true)
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
