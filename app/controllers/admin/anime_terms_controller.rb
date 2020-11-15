class Admin::AnimeTermsController < Admin::BaseController
  def edit
    @form = AnimeTermCollectionForm.new
    @form.load(params[:anime_id])
  end
  def update
  end
  def destroy
  end
end
