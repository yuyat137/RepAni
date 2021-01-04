class Admin::Animes::Episodes::TweetsImportsController < Admin::BaseController
  def new
    @episode = Episode.find(params[:episode_id]).decorate
    @twitter_search_limit = ConfirmTwitterLimitService.call(:search)
  end

  def create
    @episode = Episode.find(params[:episode_id]).decorate
    ImportTweetsService.call(@episode.id, params[:tweet_id])
    if !@episode.tweets.empty?
      redirect_to admin_anime_episode_tweets_path(@episode.id), success: 'ツイートを取得しました'
    else
      @twitter_search_limit = ConfirmTwitterLimitService.call(:search)
      flash.now[:danger] = 'ツイートが取得できませんでした'
      render :new
    end
  end

  def more_import
    @episode = Episode.find(params[:episode_id])
    tweets_min_id = @episode.tweets.order(:tweet_id).first.tweet_id
    ImportTweetsService.call(@episode.id, tweets_min_id - 1)
    redirect_to admin_anime_episode_tweets_path(@episode.id), success: 'ツイートを取得しました'
  end
end
