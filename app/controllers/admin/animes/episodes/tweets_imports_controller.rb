class Admin::Animes::Episodes::TweetsImportsController < Admin::BaseController
  def new
    @episode = Episode.find(params[:episode_id]).decorate
  end

  def create
    @episode = Episode.find(params[:episode_id])
    @episode.import_associate_tweets(params[:tweet_id]) if @episode.tweets.blank?
    redirect_to admin_anime_episode_tweets_path(@episode.id), success: 'ツイートを取得しました'
  end
end
