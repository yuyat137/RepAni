require 'nkf'

class SearchAnimesForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :title, :string
  attribute :year, :string
  attribute :season, :string
  attribute :public, :string

  def initialize(*args)
    super
    self.public = '1' if args.dig(0, :public).nil?
  end

  def search
    relation = Anime

    if title.present?
      relation = relation.where('title LIKE ?', '%' + NKF.nkf('-h1 -w', title.to_s) + '%') \
                         .or(relation.where('title LIKE ?', '%' + NKF.nkf('-h2 -w', title.to_s) + '%'))
    end

    if year.present?
      relation = relation.joins(:terms).where(terms: { year: year.to_s })
    end

    if season.present?
      relation = relation.joins(:terms).where(terms: { season: season.to_s })
    end

    unless select_public_all?
      relation = relation.where(public: str_to_bool(public))
    end

    relation.order(id: 'desc')
  end

  private

  def select_public_all?
    public.to_i == 2
  end

  def str_to_bool(str)
    ActiveRecord::Type::Boolean.new.cast(str)
  end
end
