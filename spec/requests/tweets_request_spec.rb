require 'rails_helper'

RSpec.describe "Api::Tweets", type: :request do
  let!(:anime) { create(:anime, :with_term, :with_episodes) }
  let!(:episode) { anime.episodes.first }

  context '最後のツイートを取得した場合' do
    let!(:tweets) { 20.times.collect { |i| create(:tweet, episode_id: episode.id) } }
    it 'index' do
      get api_tweets_path, params: { episode_id: episode.id, progress_time_msec: 0 }
      json = JSON.parse(response.body)
      expect(response).to have_http_status(200)
      expect(json['tweets'].length).to eq(tweets.length)
      expect(json['tweets'].first['text']).to eq(tweets.first.text)
      expect(json['last_tweet_exists']).to be true
    end
  end
  context '最後のツイートを取得しない場合' do
    let!(:tweets) { 301.times.collect { |i| create(:tweet, episode_id: episode.id) } }
    it 'index' do
      get api_tweets_path, params: { episode_id: episode.id, progress_time_msec: 0 }
      json = JSON.parse(response.body)
      expect(response).to have_http_status(200)
      expect(json['tweets'].length).to eq(300)
      expect(json['tweets'].first['text']).to eq(tweets.first.text)
      expect(json['last_tweet_exists']).to be false
    end
  end
end
