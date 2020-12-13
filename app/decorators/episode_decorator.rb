class EpisodeDecorator < ApplicationDecorator
  delegate_all

  def search_twitter
    return unless broadcast_datetime
    # もしbroadcast_datetimeがnilのときの記述書く
    broadcast_end_time = broadcast_datetime.since(air_time.minutes)
    "##{anime.twitter_hash_tag} until:#{broadcast_end_time.strftime('%Y-%m-%d_%H:%M:%S_JST')}"
  end

  def broadcast_date_and_time
    return unless broadcast_datetime
    # もしbroadcast_datetimeがnilのときの記述書く
    weeks = I18n.t 'date.abbr_day_names'
    broadcast_datetime.strftime("%Y年%m月%d日(#{weeks[broadcast_datetime.wday]}) %H時%M分")
  end
end
