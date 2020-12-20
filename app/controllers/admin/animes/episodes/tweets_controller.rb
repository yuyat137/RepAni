class Admin::Animes::Episodes::TweetsController < Admin::BaseController
  def index
    @search_form = if params.key?(:search)
                     SearchTweetsForm.new(search_params.to_h)
                   else
                     SearchTweetsForm.new(episode_id: params[:episode_id])
                   end
    @tweets = @search_form.search.page(params[:page])
  end

  private

  def search_params
    params.require(:search).permit(:episode_id, :begin_minutes, :begin_seconds, :end_minutes, :end_seconds)
  end
end
