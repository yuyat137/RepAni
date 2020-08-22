class Api::AnimesController < ApplicationController
  before_action :set_term
  def index
    animes = @term.animes
    render json: animes
  end

  private

  # TODO: set_*のbeforeアクションは不要なのかも、とのこと
  def set_term
    @term = Term.fetch_now_or_select_term(params[:year], params[:season])
  end
end
