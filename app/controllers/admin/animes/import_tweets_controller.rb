class Admin::Animes::ImportTweetsController < Admin::BaseController
  def show
    @episode = Episode.find(params[:episode_id]).decorate
  end

  def import
    @episode = Episode.find(params[:episode_id])
    return unless @episode.tweets.blank?

    @episode.import_associate_tweets(params[:tweet_id])
    if @episode.tweets.empty?
      redirect_to admin_animes_tweets_path(episode_id: @episode.id), success: 'ツイートを取得しました'
    else
      redirect_to admin_animes_import_tweets_import_path(episode_id: @episode.id), danger: 'ツイートの取得に失敗しました'
    end
  end
end
