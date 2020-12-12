class Admin::AnimesImportsController < Admin::BaseController
  def new; end

  def create
    @animes = ImportAnimesFromApiService.call(params.dig(:import_period, 'year(1i)'), params.dig(:import_period, :season))
    if !@animes.blank?
      flash.now[:success] = 'ログ欄のアニメをインポートしました'
    else
      flash.now[:danger] = '全てインポート済でした'
    end

    render :index
  end
end
