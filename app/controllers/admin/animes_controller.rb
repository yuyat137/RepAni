class Admin::AnimesController < Admin::BaseController
  # TODO: ここはストロングパラメーターにする必要無い気がする
  def index
    @search_form = SearchAnimesForm.new(search_params)
    @animes = @search_form.search.page(params[:page]).preload(:terms)
  end

  def new
    @anime = Anime.new
  end

  def create
    @anime = Anime.register(params[:anime])

    if @anime
      redirect_to admin_animes_path, success: 'アニメを登録しました'
    else
      flash.now[:danger] = 'アニメの登録に失敗しました'
      render :new
    end
  end

  def show
    @anime = Anime.find(params[:id])
  end

  def edit
    @anime = Anime.find(params[:id])
  end

  def update
    @anime = Anime.find(params[:id])
    @anime.update(anime_params)
    redirect_to admin_anime_path(@anime.id), success: '登録情報を更新しました'
  end

  def destroy
    @anime = Anime.find(params[:id])
    @anime.destroy
  end

  def switch_public
    @anime = Anime.find(params[:id])
    @anime.update(public: params[:public])
  end

  private

  def anime_params
    params.require(:anime).permit(:title, :public_url, :default_air_time, :first_broadcast_datetime, :twitter_account, :twitter_hash_tag, :public)
  end

  def search_params
    # ここ、なんでこんな書き方してるのか
    params[:search]&.permit(:title, :year, :season, :public)
  end
end
