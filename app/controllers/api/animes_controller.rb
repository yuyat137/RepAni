class Api::AnimesController < ApplicationController
  before_action :set_term
  def index
    animes = @term.animes
    render json: animes
  end

  private

  # TODO: set_*のbeforeアクションは不要なのかも、とのこと
  def set_term
    year = params[:year].to_i if params[:year]
    season = params[:season] if params[:season]
    @term = Term.get(year, season)
  end
end
