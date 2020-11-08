class Admin::AnimesController < Admin::BaseController
  def index
    @search_form = SearchAnimesForm.new(search_params)
    @animes = @search_form.search.page(params[:page])
  end

  def update
    @anime = Anime.find(params[:id])
    @anime.update(anime_params)
  end

  def show
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
  def search_params
    params[:search]&.permit(:title, :year, :season, :public)
  end
end
