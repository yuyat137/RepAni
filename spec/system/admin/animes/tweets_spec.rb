require 'rails_helper'
RSpec.describe 'admin/animes/tweets', type: :system do
  describe 'ツイート一覧画面' do
    let!(:anime) { create(:anime) }
    let!(:episode) { create(:episode, :with_tweets, anime_id: anime.id) }
    context '表示内容' do
      it 'リストに表示される内容が正しい' do
        visit admin_animes_tweets_path(episode_id: episode.id)
        tweet = episode.tweets[10]
        within("#tweet_#{tweet.id}") do
          expect(page).to have_content(tweet.tweet_id)
          expect(page).to have_content(tweet.name)
          expect(page).to have_content(tweet.screen_name)
          expect(page).to have_content(tweet.text)
          expect(page).to have_content(tweet.tweeted_at.strftime('%H:%M:%S'))
          expect(page).to have_content("(#{Time.at(tweet.tweeted_at - episode.broadcast_datetime).utc.strftime('%T')})")
        end
      end
    end
  end
  describe '検索機能' do
    let!(:anime) { create(:anime) }
    let!(:episode) { create(:episode, :with_tweets, anime_id: anime.id) }
    context '時間で検索' do
      it '始まり時間で検索できる' do
        visit admin_animes_tweets_path(episode_id: episode.id)
        select 1, from: 'search[begin_minutes]'
        select 10, from: 'search[begin_seconds]'
        click_on '検索'
        expect(page).not_to have_content(episode.tweets.first.text)
        expect(page).to have_content(episode.tweets[70].text)
      end
      it '終わり時間で検索できる' do
        visit admin_animes_tweets_path(episode_id: episode.id)
        select 2, from: 'search[end_minutes]'
        select 20, from: 'search[end_seconds]'
        click_on '検索'
        click_link '最後へ', match: :first
        expect(page).not_to have_content(episode.tweets.last.text)
        expect(page).to have_content(episode.tweets[130].text)
      end
      it '検索値がリセットできる' do
        visit admin_animes_tweets_path(episode_id: episode.id)
        select 1, from: 'search[begin_minutes]'
        select 10, from: 'search[begin_seconds]'
        select 2, from: 'search[end_minutes]'
        select 30, from: 'search[end_seconds]'
        click_on 'リセット'
        click_on '検索'
        expect(page).to have_content(episode.tweets.first.text)
        click_link '最後へ', match: :first
        expect(page).to have_content(episode.tweets.last.text)
      end
    end
  end
end
