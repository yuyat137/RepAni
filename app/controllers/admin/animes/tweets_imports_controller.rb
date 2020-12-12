class Admin::Animes::TweetsImportsController < Admin::BaseController
  def new
    @episode = Episode.find(params[:episode_id]).decorate
  end

  def create
    @episode = Episode.find(params[:episode_id])
    @episode.import_associate_tweets(params[:tweet_id]) if @episode.tweets.blank?
    redirect_to admin_animes_tweets_path(episode_id: @episode.id), success: 'ツイートを取得しました'
  end
end
