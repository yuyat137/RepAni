require 'rails_helper'

RSpec.describe "Api::Tweets", type: :request do
  let!(:anime) { create(:anime, :associate_term, :episodes) }
  let!(:episode) { anime.episodes.first }

  context '最後のツイートを取得した場合' do
    let!(:tweets) { 20.times.collect { |i| create(:tweet, episode_id: episode.id, serial_number: i + 1) } }
    it 'index' do
      get api_tweets_path, params: { episode_id: episode.id, progress_time_msec: 0 }
      json = JSON.parse(response.body)
      expect(response).to have_http_status(200)
      expect(json['tweets'].length).to eq(tweets.length)
      expect(json['tweets'].first['text']).to eq(tweets.first.text)
      expect(json['fetch_last_tweet']).to be true
    end
  end
  context '最後のツイートを取得しない場合' do
    let!(:tweets) { 301.times.collect { |i| create(:tweet, episode_id: episode.id, serial_number: i + 1) } }
    it 'index' do
      get api_tweets_path, params: { episode_id: episode.id, progress_time_msec: 0 }
      json = JSON.parse(response.body)
      expect(response).to have_http_status(200)
      expect(json['tweets'].length).to eq(300)
      expect(json['tweets'].first['text']).to eq(tweets.first.text)
      expect(json['fetch_last_tweet']).to be false
    end
  end
end
