class Admin::TermsController < Admin::BaseController

  def edit_anime_terms
    # params[:anime_id]
    @form = TermCollectionForm.new
    @form.load(params[:anime_id])
  end

  def update_anime_terms
  end

end
