class Anime < ApplicationRecord
  before_validation :set_public
  has_many :anime_terms, dependent: :destroy
  has_many :terms, through: :anime_terms
  has_many :episodes, dependent: :destroy
  accepts_nested_attributes_for :terms, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :episodes, reject_if: :all_blank, allow_destroy: true
  validates :title, presence: true, uniqueness: { case_sensitive: false }
  validates :default_air_time, presence: true
  validates :public, inclusion: { in: [true, false] }

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
    end
  end

  def register_term(year, season_num)
    return if year.blank? || season_num.blank?

    # TODO: このseason_numの値は"winter"で送っても0で送っても良いようにしたい
    term = Term.find_or_create_by!(year: year.to_i, season: season_num.to_i)
    return if anime_terms.map(&:term_id).include?(term&.id)

    anime_terms.create!(term_id: term.id)
  end

  private

  def set_public
    self.public = :open if public.nil?
  end
end
