require 'rails_helper'

RSpec.describe "Api::Tweets", type: :request do
  let!(:anime) { create(:anime, :associate_term, :episodes) }
  let!(:episode) { anime.episodes.first }
  let!(:tweets) { create_list(:tweet, 20, episode_id: episode.id) }
  it 'index' do
    get api_tweets_path, params: { episode_id: episode.id }
    json = JSON.parse(response.body)
    expect(response).to have_http_status(200)
    expect(json.length).to eq(tweets.length)
    expect(json.first['text']).to eq(tweets.first.text)
  end
end
