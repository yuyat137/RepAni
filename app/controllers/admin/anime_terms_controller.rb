class Admin::AnimeTermsController < Admin::BaseController
  def edit
    @anime = Anime.find(params[:anime_id])
  end

  def update
    @anime = Anime.find(params[:anime_id])
    @anime.terms.destroy_all
    params.dig(:anime, :terms_attributes)&.each do |key, value|
      @anime.register_term(value[:year], Term.seasons[value[:season]]) unless ActiveRecord::Type::Boolean.new.cast(value[:_destroy])
    end
    redirect_to admin_anime_path(@anime)
  end
end
