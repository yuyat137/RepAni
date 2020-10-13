class SearchAnimesForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  # scope :body_contain, ->(word) { left_joins(:sentences).where('sentences.body LIKE ?', "%#{word}%") }
  attribute :title, :string

  def search
    relation = Anime

    if title.present?
      relation = relation.where('title LIKE ?', "%#{title}%")
    end

    relation.order(:title)
  end
end
