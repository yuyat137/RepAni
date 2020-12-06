class SearchTweetsForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :episode_id, :integer
  # string型なのはセレクトボックスが文字列で渡るため。違和感はある。
  attribute :begin_hours, :string
  attribute :begin_minutes, :string
  attribute :begin_seconds, :string
  attribute :end_hours, :string
  attribute :end_minutes, :string
  attribute :end_seconds, :string

  def search
    relation = Episode.find(episode_id).tweets

    if begin_hours.present? || begin_minutes.present? || begin_seconds.present?
      milliseconds = (begin_hours.to_i*60*60 + begin_minutes.to_i*60 + begin_seconds.to_i)*1000
      relation = relation.where(progress_time_msec: milliseconds..Float::MAX)
    end

    if end_hours.present? || end_minutes.present? || end_seconds.present?
      milliseconds = (end_hours.to_i*60*60 + end_minutes.to_i*60 + end_seconds.to_i)*1000
      relation = relation.where(progress_time_msec: Float::MIN..milliseconds)
    end
    relation.order(serial_number: 'asc')
  end

  def hours
    episode = Episode.find(episode_id)
    [*0..(episode.air_time/60)]
  end

  def minutes
    episode = Episode.find(episode_id)
    [*0..(episode.air_time - 1)]
  end

  def seconds
    [*0..59]
  end
end
