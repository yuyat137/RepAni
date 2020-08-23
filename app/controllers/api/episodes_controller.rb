class Api::EpisodesController < ApplicationController
  def index
    episodes = Anime.find(params[:id]).episodes
    render json: episodes
  end

  def info
    episode = Episode.find(params[:episode_id])
    anime = episode.anime
    render json: {episode: episode, anime: anime }
  end
end
