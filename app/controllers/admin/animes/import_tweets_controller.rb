class Admin::Animes::ImportTweetsController < Admin::BaseController
  def show
    @episode = Episode.find(params[:episode_id]).decorate
  end

  def import
    # Anime.all[24].episodes[10].import_associate_tweets(max_tweet_id)

    # @tweets = ImportAnimesFromApiService.call(params.dig(:import_period, 'year(1i)'), params.dig(:import_period, :season))
    # if !@animes.blank?
    #   flash.now[:success] = 'ログ欄のアニメをインポートしました'
    # else
    #   flash.now[:danger] = '全てインポート済でした'
    # end

    # render :index
  end
end
