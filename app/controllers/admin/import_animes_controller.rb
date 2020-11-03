class Admin::ImportAnimesController < Admin::BaseController

  def index; end

  def import
    @animes = Anime.import_this_term_from_api(params.dig(:import_period, 'year(1i)'), params.dig(:import_period, :season))
    if @animes.blank?
      flash.now[:danger] = '全てインポート済でした'
    else
      flash.now[:success] = 'ログ欄のアニメをインポートしました'
    end

    render :index
  end
end
