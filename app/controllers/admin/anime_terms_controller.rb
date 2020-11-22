class Admin::AnimeTermsController < Admin::BaseController
  def edit
    @anime = Anime.find(params[:anime_id])
  end

  def update
    @anime = Anime.find(params[:anime_id])
    @anime.terms.destroy_all
    params.dig(:anime, :terms_attributes)&.each do |_key, value|
      next if ActiveRecord::Type::Boolean.new.cast(value[:_destroy])

      @anime.register_term(value[:year], Term.seasons[value[:season]])
    end
    redirect_to admin_anime_path(@anime), success: '放送時期を更新しました'
  end
end
