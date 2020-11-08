class Api::AnimesController < ApplicationController
  def index
    term = Term.fetch_now_or_select_term(params[:year], Term.seasons[params[:season]])
    render json: term.animes
  end
end
