class Admin::AnimesController < Admin::BaseController
  def index
    @search_form = SearchAnimesForm.new(search_params)
    @animes = @search_form.search.page(params[:page])
  end

  def update
    @anime = Anime.find(params[:id])
    @anime.update(public: anime_public_param)
  end

  def destroy
    @anime = Anime.find(params[:id])
    @anime.destroy
  end

  private

  def anime_public_param
    params.require(:public)
  end

  def search_params
    params[:search]&.permit(:title, :year, :season, :public)
  end
end
