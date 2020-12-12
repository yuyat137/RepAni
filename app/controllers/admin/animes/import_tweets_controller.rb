class Admin::Animes::ImportTweetsController < Admin::BaseController
  def show
    @episode = Episode.find(params[:episode_id]).decorate
  end

  def import
    @episode = Episode.find(params[:episode_id])
    @episode.import_associate_tweets(params[:tweet_id]) if @episode.tweets.blank?
    redirect_to admin_animes_tweets_path(episode_id: @episode.id), success: 'ツイートを取得しました'
  end
end
