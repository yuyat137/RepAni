class ImportAnimesFromApiService
  private_class_method :new
  RESPONSE_SUCCESS = '200'.freeze
  SHANGRILA_API_URI = 'http://api.moemoe.tokyo/anime/v1/master/'.freeze

  def self.call(year = nil, season_num = nil)
    new.call(year, season_num)
  end

  def call(year, season_num)
    term = Term.fetch_now_or_select_term(year, season_num)

    api_end_point = SHANGRILA_API_URI + term.year.to_s + '/' + term.season_before_type_cast.to_s
    response = Net::HTTP.get_response URI.parse(api_end_point)
    return if response.code != RESPONSE_SUCCESS

    json = JSON.parse(response.body, symbolize_names: true)
    animes = []
    anime_terms = []
    json.each do |anime|
      anime.slice!(:title, :public_url, :twitter_account, :twitter_hash_tag)
      new_anime = Anime.new(anime)
      next unless new_anime.valid?

      # NOTE: saveしてからでないとidが取得できないため、Animeにbulk insertは使わない
      new_anime.save
      animes << new_anime
      anime_terms << new_anime.anime_terms.new(term_id: term.id)
    end
    AnimeTerm.import anime_terms, validate: true
    Term.update_all_now_attribute
    animes
  end
end
