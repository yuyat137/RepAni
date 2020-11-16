class Admin::AnimesController < Admin::BaseController
  # TODO: ここはストロングパラメーターにする必要無い気がする
  def index
    @search_form = SearchAnimesForm.new(search_params)
    @animes = @search_form.search.page(params[:page])
  end

  def update
    @anime = Anime.find(params[:id])
    @anime.update(anime_params)
    redirect_to admin_anime_path(@anime.id), success: '登録情報を更新しました'
  end

  def show
    @anime = Anime.find(params[:id])
  end

  def edit
    @anime = Anime.find(params[:id])
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
    params.require(:anime).permit(:title, :public_url, :default_air_time, :twitter_account, :twitter_hash_tag, :public)
  end

  def search_params
    params[:search]&.permit(:title, :year, :season, :public)
  end
end
