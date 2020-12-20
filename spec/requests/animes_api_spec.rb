require 'rails_helper'

RSpec.describe "Api::Animes", type: :request do
  let!(:anime) { create(:anime, :with_term) }
  let!(:get_params) { { year: anime.terms.first.year, season: anime.terms.first.season } }
  it 'index' do
    get api_animes_path, params: get_params
    json = JSON.parse(response.body)
    expect(response).to have_http_status(200)
    expect(json.length).to eq(1)
    expect(json.first['title']).to eq(anime.title)
  end
end
