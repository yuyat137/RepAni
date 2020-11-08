class Admin::ImportAnimesController < Admin::BaseController
  def index; end

  def create
    result = Anime.register(params[:anime])

    if result
      flash.now[:success] = 'アニメを登録しました'
    else
      flash.now[:danger] = 'アニメの登録に失敗しました'
    end

    render :index
  end

  def import
    @animes = ImportAnimesFromApiService.call(params.dig(:import_period, 'year(1i)'), params.dig(:import_period, :season))
    if !@animes.blank?
      flash.now[:success] = 'ログ欄のアニメをインポートしました'
    else
      flash.now[:danger] = '全てインポート済でした'
    end

    render :index
  end
end
