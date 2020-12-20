require 'rails_helper'

RSpec.describe "Api::Episodes", type: :request do
  let!(:anime) { create(:anime, :with_term, :with_episodes) }
  let!(:episode) { anime.episodes.first }
  it 'index' do
    get api_episodes_path, params: { id: anime.id }
    json = JSON.parse(response.body)
    expect(response).to have_http_status(200)
    expect(json.length).to eq(anime.episodes.length)
    expect(json.first['subtitle']).to eq(episode.subtitle)
  end
  it 'info' do
    get info_api_episodes_path, params: { episode_id: episode.id }
    json = JSON.parse(response.body)
    expect(response).to have_http_status(200)
    expect(json["anime"]["title"]).to eq(anime.title)
    expect(json["episode"]['subtitle']).to eq(episode.subtitle)
  end
end
