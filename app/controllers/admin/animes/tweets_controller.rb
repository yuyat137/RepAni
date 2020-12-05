class Admin::Animes::TweetsController < Admin::BaseController
  def index
    episode = Episode.find(params[:episode_id])
    @tweets = episode.tweets.page params[:page]
  end
end
