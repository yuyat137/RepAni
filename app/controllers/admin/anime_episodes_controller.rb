class Admin::AnimeEpisodesController < Admin::BaseController
  def edit
    @anime = Anime.find(params[:anime_id])
  end

  def update
    @anime = Anime.find(params[:anime_id])
    result = @anime.update_episodes(params.dig(:anime, :episodes_attributes))
    if result
      redirect_to admin_anime_path(@anime), success: 'エピソードを更新しました'
    else
      flash.now[:danger] = '更新に失敗しました'
      render :edit
    end
  end
end
