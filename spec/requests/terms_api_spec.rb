require 'rails_helper'

RSpec.describe "Api::Terms", type: :request do
  let!(:term) { create(:term) }
  it 'index' do
    get api_terms_path
    json = JSON.parse(response.body)
    expect(response).to have_http_status(200)
    expect(json.length).to eq(1)
    expect(json.first['year']).to eq(term.year)
    expect(json.first['season']).to eq(term.season)
  end
end
