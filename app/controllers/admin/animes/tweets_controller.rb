class Admin::Animes::TweetsController < Admin::BaseController
  def index
    if params.has_key?(:search)
      @search_form = SearchTweetsForm.new(search_params)
    else
      @search_form = SearchTweetsForm.new(episode_id: params[:episode_id])
    end
    @tweets = @search_form.search.page(params[:page])
  end

  private

  def search_params
    params.require(:search).permit(:episode_id, :begin_minutes, :begin_seconds, :end_minutes, :end_seconds)
  end
end
