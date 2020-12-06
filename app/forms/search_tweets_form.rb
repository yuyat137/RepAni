class SearchTweetsForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :episode_id, :integer
  # string型なのはセレクトボックスが文字列で渡るため。違和感はある。
  attribute :begin_minutes, :string
  attribute :begin_seconds, :string
  attribute :end_minutes, :string
  attribute :end_seconds, :string

  def initialize(params)
    # TODO: issue#68
    super
    self.episode_id = params[:episode_id]
    episode = Episode.find(episode_id)
    self.begin_minutes = params['begin_minutes'] || '0'
    self.begin_seconds = params['begin_seconds'] || '0'
    self.end_minutes = params['end_minutes'] || (episode.air_time - 1).to_s
    self.end_seconds = params['end_seconds'] || '59'
  end

  def search
    relation = Episode.find(episode_id).tweets

    if begin_minutes.present? || begin_seconds.present?
      milliseconds = (begin_minutes.to_i * 60 + begin_seconds.to_i) * 1000
      relation = relation.where(progress_time_msec: milliseconds..Float::MAX)
    end

    if end_minutes.present? || end_seconds.present?
      milliseconds = (end_minutes.to_i * 60 + end_seconds.to_i) * 1000
      relation = relation.where(progress_time_msec: Float::MIN..milliseconds)
    end
    relation.order(serial_number: 'asc')
  end

  def minutes
    episode = Episode.find(episode_id)
    [*0..(episode.air_time - 1)]
  end

  def seconds
    [*0..59]
  end
end
