class Admin::ImportAnimesController < Admin::BaseController

  def index
    @animes = []
    @result = 'エラーログを表示します'
  end

  def import
    # TODO: インスタンス変数にメッセージを格納する今のコードは変えたい
    @animes = Anime.import_this_term_from_api(params.dig(:import_period, 'year(1i)'), params.dig(:import_period, :season))
    if @animes.blank?
      @result = '全てインポート済でした'
    else
      @result = '以下のアニメをインポートしました'
    end

    render :index
  end
end
