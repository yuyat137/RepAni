class Api::AnimesController < ApplicationController
  before_action :set_term
  def index
    animes = @term.animes
    render json: animes
  end

  private

  def set_term
    # TODO: pages/anime/index.vueにも書いたが、ここに渡ってくるパラメーターがenumの数字なのか文字列なのか統一していない
    year = params[:year].to_i if params[:year]
    season = params[:season] if params[:season]
    @term = Term.get(year, season)
  end
end
