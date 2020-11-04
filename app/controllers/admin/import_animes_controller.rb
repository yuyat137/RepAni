class Admin::ImportAnimesController < Admin::BaseController
  def index; end

  def create
    result = Anime.register(
      title: params[:anime][:title],
      public_url: params[:anime][:public_url],
      default_air_time: params[:anime][:default_air_time].to_i,
      twitter_account: params[:anime][:twitter_account],
      public: params[:anime][:public],
      year: params[:anime]['year(1i)'].to_i,
      season: params[:anime][:season].to_i,
      episodes_num: params[:anime][:episodes_num].to_i
    )

    if result
      flash.now[:success] = 'アニメを登録しました'
    else
      flash.now[:danger] = 'アニメの登録に失敗しました'
    end

    render :index
  end

  def import
    @animes = Anime.import_this_term_from_api(params.dig(:import_period, 'year(1i)'), params.dig(:import_period, :season))
    if !@animes.blank?
      flash.now[:success] = 'ログ欄のアニメをインポートしました'
    else
      flash.now[:danger] = '全てインポート済でした'
    end

    render :index
  end
end
