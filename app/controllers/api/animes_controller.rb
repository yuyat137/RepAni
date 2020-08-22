class Api::AnimesController < ApplicationController
  before_action :set_term
  def index
    animes = @term.animes
    render json: animes
  end

  private

  # TODO: set_*のbeforeアクションは不要なのかも、とのこと
  def set_term
    @term = if params[:year] && params[:season]
              Term.fetch_term(params[:year], params[:season])
            else
              Term.now_term
            end
  end
end
