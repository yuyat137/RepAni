require 'rails_helper'

RSpec.describe "Api::Animes", type: :request do
  describe 'Animeのindex' do
    let!(:anime) { create(:anime) }
    it '全てのポストを取得する' do
      get api_animes_path
      json = JSON.parse(response.body)
      expect(response).to have_http_status(200)
      expect(json.length).to eq(1)
      expect(json.first['title']).to eq(anime.title)
    end
  end
end
