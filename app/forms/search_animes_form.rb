require 'nkf'

class SearchAnimesForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :title, :string
  attribute :year, :string
  attribute :season, :string
  attribute :public, :string

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

    if initial_display?
      self.public = 1
      relation = relation.where(public: true)
    elsif select_public_or_private?
      relation = relation.where(public: convert_public_to_bool)
    end

    relation.order(id: 'desc')
  end

  private

  def initial_display?
    public.nil?
  end

  def select_public_or_private?
    !public.to_i.zero?
  end

  def convert_public_to_bool
    select_num = public.to_i
    if select_num == 1
      true
    elsif select_num == 2
      false
    end
  end
end
