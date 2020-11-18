class Admin::AnimeEpisodesController < Admin::BaseController
  def edit
    @anime = Anime.find(params[:anime_id])
  end

  def update
    @anime = Anime.find(params[:anime_id])
    # 放送時間を空欄にするとエラーになる。その他、エラーになったときの処理を書く
    if @anime.update(update_episode_params)
      redirect_to admin_anime_path(@anime), success: 'エピソードを更新しました'
    else
      render :edit
    end
  end

  private

  def update_episode_params
    params.require(:anime).permit(episodes_attributes: [:id, :num, :subtitle, :broadcast_datetime, :air_time, :active])
  end
end
