class TweetDecorator < ApplicationDecorator
  delegate_all

  def elapsed_time
    Time.at(tweeted_at - episode.broadcast_datetime).utc.strftime('%T')
  end
end
