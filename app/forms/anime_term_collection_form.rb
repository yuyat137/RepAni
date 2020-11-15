class AnimeTermCollectionForm
  include ActiveModel::Model
  include ActiveModel::Callbacks
  include ActiveModel::Validations
  include ActiveModel::Validations::Callbacks

  attr_accessor :anime_id
  attr_accessor :terms
  DEFAULT_NUM = 3

  # def initialize(anime_id)
    # self.anime_id = anime_id
    # if anime_id.present?
    #   self.terms = Anime.find(anime_id).terms.map do |term|
    #     Term.new(
    #       year: term['year'],
    #       season: term['season'],
    #       season_ja: term['season_ja'],
    #       now: term['now']
    #     )
    #   end
    # else
    #   self.collection = DEFAULT_NUM.times.map{ Term.new }
    # end
  # end

  def load(anime_id)
    self.anime_id = anime_id
    self.terms = Anime.find(anime_id).terms.to_a
  end

  def terms_attributes=(attributes)
    self.products = attributes.map do |_, product_attributes|
      TermCollectionForm.new(product_attributes).tap { |v| v.availability = false }
    end
  end

  def save
    return false unless valid?
    Term.transaction { target_terms.each(&:save!) }
    true
  end
end
