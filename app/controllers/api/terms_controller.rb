class Api::TermsController < ApplicationController
  def index
    terms = Term.all
    render json: terms
  end
end
