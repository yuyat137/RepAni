class Anime < ApplicationRecord
  before_validation :set_public
  has_many :anime_terms, dependent: :destroy
  has_many :terms, through: :anime_terms, dependent: :destroy
  has_many :episodes, dependent: :destroy
  validates :title, presence: true, uniqueness: { case_sensitive: false }
  validates :public, inclusion: { in: [true, false] }
  RESPONSE_SUCCESS = '200'.freeze
  SHANGRILA_API_URI = 'http://api.moemoe.tokyo/anime/v1/master/'.freeze

  # TODO: サービスオブジェクトにするか検討
  def self.import_this_term_from_api(year = nil, season_num = nil)
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

  def import_associate_episodes(episode_num, first_broadcast_date = nil)
    new_episodes = []
    episode_num.times do |num|
      new_episodes << if first_broadcast_date
                        Episode.new(anime_id: id, num: num + 1, air_time: default_air_time, broadcast_datetime: first_broadcast_date + 7 * num)
                      else
                        Episode.new(anime_id: id, num: num + 1, air_time: default_air_time)
                      end
    end
    Episode.import new_episodes
  end

  def self.register(params)
    ActiveRecord::Base.transaction do
      year = params['year(1i)'] || params[:year]
      anime = Anime.create!(title: params[:title],
                            public_url: params[:public_url],
                            default_air_time: params[:default_air_time],
                            twitter_account: params[:twitter_account],
                            public: params[:public])
      term = Term.find_or_create_by!(year: year.to_i, season: params[:season].to_i)
      anime.anime_terms.create!(term_id: term.id)
      anime.import_associate_episodes(params[:episodes_num].to_i)
    end
  end

  private

  def set_public
    self.public = :open if public.nil?
  end
end
