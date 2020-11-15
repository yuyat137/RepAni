class Admin::AnimeTermsController < Admin::BaseController

  def edit
    # Animeオブジェクトを継承したらうまくいった
    # これって、フォームオブジェクト使う必要あるのか
    @form = AnimeTermCollectionForm.new
    @form.load(params[:anime_id])
  end

  def update
  end

  def destroy
  end

end
