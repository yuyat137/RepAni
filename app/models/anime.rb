class Anime < ApplicationRecord

  def self.import_by_api(year=nil, season=nil)
    year =  Date.today.year unless year
    season = (Date.today.month - 1)/3 + 1 unless season

    url = "http://api.moemoe.tokyo/anime/v1/master/" + year.to_s + "/" + season.to_s
    response = Net::HTTP.get_response URI.parse(url)
    return if response.code != "200"

    results = JSON.parse(response.body, symbolize_names: :true)
    results.map!{ |anime| anime.slice(:title, :title_short1, :public_url, :twitter_account, :twitter_hash_tag, :sex, :sequel)}
    return if results.blank?

    # TODO: リファクタリング対応
    results.each do |result|
      tmp1 = result[:title_short1]
      result[:title_short] = tmp1
      result.delete(:title_short1)
      tmp2 = result[:sex]
      result[:target_sex] = tmp2
      result.delete(:sex)
    end

    animes = []
    results.each do |result|
      animes << Anime.new(result)
    end
    Anime.import animes, validate: true
  end
end
