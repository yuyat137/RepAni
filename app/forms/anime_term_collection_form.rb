class AnimeTermCollectionForm < Anime
  include ActiveModel::Model
  include ActiveModel::Callbacks
  include ActiveModel::Validations
  include ActiveModel::Validations::Callbacks
  # has_many :terms, class_name: 'Term'
  # has_many :terms

  attr_accessor :anime_id
  attr_accessor :terms
  DEFAULT_NUM = 3

  # def initialize(anime_id)
  # end

  def load(anime_id)
    self.anime_id = anime_id
    self.terms = Anime.find(anime_id).terms
  end

  def terms_attributes=(attributes)
    self.terms = attributes.map { |_, term_params| Term.new(term_params) }
  end

  def save
    return false unless valid?
    Term.transaction { target_terms.each(&:save!) }
    true
  end
end
