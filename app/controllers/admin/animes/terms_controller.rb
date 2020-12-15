class Admin::Animes::TermsController < Admin::BaseController
  def edit
    @anime = Anime.find(params[:anime_id])
  end

  def update
    @anime = Anime.find(params[:anime_id])
    @anime.terms.destroy_all

    redirect_to admin_anime_path(@anime), success: '放送時期を更新しました'
  end
end
