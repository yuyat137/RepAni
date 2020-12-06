class SearchTweetsForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :episode_id, :integer

  def search
    relation = Episode.find(episode_id).tweets

    # if year.present?
    #   relation = relation.joins(:terms).where(terms: { year: year.to_s })
    # end

    # if season.present?
    #   relation = relation.joins(:terms).where(terms: { season: season.to_s })
    # end

    relation.order(id: 'desc')
  end
end
