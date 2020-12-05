class Admin::Animes::ImportTweetsController < Admin::BaseController
  def show
    @episode = Episode.find(params[:episode_id]).decorate
  end

  def import
    # 動作確認まだ
    # @episode = Episode.find(params[:episode_id])
    # return unless @episode.tweets.blank?

    # @episode.import_associate_tweets(params[:tweet_id])

    # if !@episode.tweets.blank?
    #   redirect_to '#', success: 'ツイートをインポートしました'
    # else
    #   flash.now[:success] = 'ツイートのインポートに失敗しました'
    #   render :show
    # end
  end
end
