require 'rails_helper'

RSpec.describe "Api::Tweets", type: :request do
  let!(:anime) { create(:anime, :associate_term, :episodes) }
  let!(:episode) { anime.episodes.first }
  let!(:tweets) { 20.times.collect { |i| create(:tweet, episode_id: episode.id, serial_number: i + 1) } }

  it 'index' do
    get api_tweets_path, params: { episode_id: episode.id, progress_time_msec: 0 }
    json = JSON.parse(response.body)
    expect(response).to have_http_status(200)
    expect(json["tweets"].length).to eq(tweets.length)
    expect(json["tweets"].first['text']).to eq(tweets.first.text)
  end
end
