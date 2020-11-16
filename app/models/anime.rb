class Anime < ApplicationRecord
  before_validation :set_public
  has_many :anime_terms, dependent: :destroy
  has_many :terms, through: :anime_terms
  has_many :episodes, dependent: :destroy
  accepts_nested_attributes_for :terms, reject_if: :all_blank, allow_destroy: true
  validates :title, presence: true, uniqueness: { case_sensitive: false }
  validates :public, inclusion: { in: [true, false] }

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
      season_num = params[:season]
      anime = Anime.create!(title: params[:title],
                            public_url: params[:public_url],
                            default_air_time: params[:default_air_time],
                            twitter_account: params[:twitter_account],
                            twitter_hash_tag: params[:twitter_hash_tag],
                            public: params[:public])
      anime.register_term(year, season_num)
      anime.import_associate_episodes(params[:episodes_num].to_i)
    end
  end

  def register_term(year, season_num)
    # TODO: このseason_numの値は"winter"で送っても0で送っても良いようにしたい
    term = Term.find_or_create_by!(year: year.to_i, season: season_num.to_i)
    anime_terms.create!(term_id: term.id)
  end

  private

  def set_public
    self.public = :open if public.nil?
  end
end
