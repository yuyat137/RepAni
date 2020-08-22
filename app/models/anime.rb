class Anime < ApplicationRecord
  before_validation :set_state
  before_save :set_default_air_time
  has_many :anime_terms
  has_many :terms, through: :anime_terms
  has_many :episodes
  validates :title, presence: true, uniqueness: { case_sensitive: false }
  validates :state, presence: true
  enum state: %i[close open]
  RESPONSE_SUCCESS = '200'.freeze
  SHANGRILA_API_URI = 'http://api.moemoe.tokyo/anime/v1/master/'.freeze

  # TODO: サービスオブジェクトにするか検討
  def self.import_this_term_from_api(year = nil, season = nil)
    term = year && season ? Term.find_or_create_by(year: year, season: season) : Term.now_term

    api_end_point = SHANGRILA_API_URI + term.year.to_s + '/' + term.season_before_type_cast.to_s
    response = Net::HTTP.get_response URI.parse(api_end_point)
    return if response.code != RESPONSE_SUCCESS

    json = JSON.parse(response.body, symbolize_names: true)
    json.each do |anime|
      anime.slice!(:title, :public_url, :twitter_account, :twitter_hash_tag)
      new_anime = Anime.new(anime)
      next unless new_anime.valid?

      new_anime.save
      new_anime.anime_terms.create(term: term)
    end
    Term.update_all_now_attribute
  end

  def import_associate_episodes(episode_num)
    new_episodes = []
    episode_num.times do |num|
      new_episodes << episodes.new(num: num + 1)
    end
    Episode.import new_episodes, on_duplicate_key_ignore: true
  end

  private

  def set_state
    self.state = :open if state.nil?
  end

  def set_default_air_time
    self.default_air_time = 30 if default_air_time.nil?
  end
end
