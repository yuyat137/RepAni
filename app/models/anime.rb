class Anime < ApplicationRecord
  validates :title, presence: true
  enum season: {winter: 1, spring: 2, summer: 3, autumn: 4}

  def self.import_by_api(year = nil, season = nil)
    year ||= Date.today.year
    season ||= (Date.today.month - 1) / 3 + 1

    url = 'http://api.moemoe.tokyo/anime/v1/master/' + year.to_s + '/' + season.to_s
    response = Net::HTTP.get_response URI.parse(url)
    return if response.code != '200'

    json = JSON.parse(response.body, symbolize_names: true)
    animes = []
    quarter_info = { year: year, season: season }
    json.each do |anime|
      anime.slice!(:title, :public_url, :twitter_account, :twitter_hash_tag)
      anime.merge!(quarter_info)
      animes << anime
    end
    return if animes.blank?

    Anime.import animes, validate: true
  end
end
