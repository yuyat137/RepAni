class SearchAnimesForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  # scope :body_contain, ->(word) { left_joins(:sentences).where('sentences.body LIKE ?', "%#{word}%") }
  attribute :title, :string
  attribute :year, :string
  attribute :season, :string

  def search
    relation = Anime

    if title.present?
      relation = relation.where('title LIKE ?', "%#{title}%")
    end

    if year.present?
      relation = relation.joins(:terms).where(terms: {year: "#{year}"})
    end

    if season.present?
      relation = relation.joins(:terms).where(terms: {season: "#{season}"})
    end

    relation.order(id: 'desc')
  end
end
