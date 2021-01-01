class Admin::Animes::Episodes::TweetsImportsController < Admin::BaseController
  def new
    @episode = Episode.find(params[:episode_id]).decorate
  end

  def create
    @episode = Episode.find(params[:episode_id])
    ImportTweetsService.call(@episode.id, params[:tweet_id])
    redirect_to admin_anime_episode_tweets_path(@episode.id), success: 'ツイートを取得しました'
  end

  def more_import
    @episode = Episode.find(params[:episode_id])
    tweet_id = @episode.tweets.last.id
    ImportTweetsService.call(@episode.id, tweet_id)
    redirect_to admin_anime_episode_tweets_path(@episode.id), success: 'ツイートを取得しました'
  end
end
