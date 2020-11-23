class Admin::EpisodesController < Admin::BaseController
  def index
    @anime = Anime.find(params[:id])
  end
end
