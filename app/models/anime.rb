class Anime < ApplicationRecord
  has_many :anime_terms
  has_many :terms, through: :anime_terms
  validates :title, presence: true, uniqueness: { case_sensitive: false }

  def self.import_by_api(year = nil, season = nil)
    term = Term.get(year, season)
    url = 'http://api.moemoe.tokyo/anime/v1/master/' + term.year.to_s + '/' + term.season_before_type_cast.to_s
    response = Net::HTTP.get_response URI.parse(url)
    return if response.code != '200'

    json = JSON.parse(response.body, symbolize_names: true)
    # TODO: 以下の箇所、リファクタリングする余地あり。サービスオブジェクト？
    json.each do |anime|
      anime.slice!(:title, :public_url, :twitter_account, :twitter_hash_tag)
      created_anime = Anime.new(anime)
      next unless created_anime.valid?
      created_anime.save
      created_anime.anime_terms.create(term: term)
    end
  end
end
