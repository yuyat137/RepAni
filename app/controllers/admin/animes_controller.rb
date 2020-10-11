class Admin::AnimesController < Admin::BaseController
  def index
    @animes = Anime.all
  end

  def update
    @anime = Anime.find(params[:id])
    @anime.update(public: anime_public_param)
  end

  def destroy
    @anime = Anime.find(params[:id])
    @anime.destroy
    redirect_to admin_animes_path
  end

  private

  def anime_public_param
    params.require(:public)
  end
end
