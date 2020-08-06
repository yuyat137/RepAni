class Anime < ApplicationRecord

  def self.import_by_api(year=nil, season=nil)
    year =  Date.today.year unless year
    season = (Date.today.month - 1)/3 + 1 unless season

    url = "http://api.moemoe.tokyo/anime/v1/master/" + year.to_s + "/" + season.to_s
    response = Net::HTTP.get_response URI.parse(url)
    return if response.code != "200"

    results = JSON.parse(response.body, symbolize_names: :true)
    results.map!{ |anime| anime.slice(:title, :public_url, :twitter_account, :twitter_hash_tag, :sex, :sequel)}
    return if results.blank?

    Anime.import results, validate: true
  end
end
