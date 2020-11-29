class Admin::Animes::EpisodesController < Admin::BaseController
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

  def destroy
    # TODO: 現状、params[:anime_id]を使用しないので違和感がある。
    #       controller側で違和感をなくすと、routes.rbで違和感が生じる
    @episode = Episode.find(params[:episode_id])
    @episode.destroy
  end
end
