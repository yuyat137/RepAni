class SearchTweetsForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attribute :episode_id, :integer
  # string型なのはセレクトボックスが文字列で渡るため。違和感はある。
  attribute :begin_minutes, :string
  attribute :begin_seconds, :string
  attribute :end_minutes, :string
  attribute :end_seconds, :string

  def initialize(*args)
    # TODO: issue#68
    super
    self.episode_id = args[0][:episode_id]
    episode = Episode.find(episode_id)
    self.begin_minutes = args[0][:begin_minutes] || '0'
    self.begin_seconds = args[0][:begin_seconds] || '0'
    self.end_minutes = args[0][:end_minutes] || (episode.air_time - 1).to_s
    self.end_seconds = args[0][:end_seconds] || '59'
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
    relation.order(:tweet_id)
  end

  def minutes
    episode = Episode.find(episode_id)
    [*0..(episode.air_time - 1)]
  end

  def seconds
    [*0..59]
  end
end
