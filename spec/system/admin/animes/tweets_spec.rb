require 'rails_helper'
RSpec.describe 'admin/animes/tweets', type: :system do
  describe 'ツイート一覧画面' do
    let!(:anime) { create(:anime) }
    let!(:episode) { create(:episode, :with_tweets, anime_id: anime.id) }
    let!(:admin_user) { create(:user, role: 'admin') }
    before { admin_login_as(admin_user) }
    context '表示内容' do
      it 'リストに表示される内容が正しい' do
        visit admin_anime_episode_tweets_path(episode.id)
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
    let!(:admin_user) { create(:user, role: 'admin') }
    before { admin_login_as(admin_user) }
    context '時間で検索' do
      it '始まり時間で検索できる' do
        # メソッド化しても良いかも
        # 作る場合、シリアルナンバー振り直しても良いかも
        tweet_69_seconds_later = create(:tweet, episode_id: episode.id, progress_time_msec: 69 * 1000, tweeted_at: episode.broadcast_datetime.advance(seconds: 69))
        tweet_70_seconds_later = create(:tweet, episode_id: episode.id, progress_time_msec: 70 * 1000, tweeted_at: episode.broadcast_datetime.advance(seconds: 70))
        visit admin_anime_episode_tweets_path(episode.id)
        select 1, from: 'search[begin_minutes]'
        select 10, from: 'search[begin_seconds]'
        click_on '検索'
        expect(page).not_to have_content(tweet_69_seconds_later.text)
        expect(page).to have_content(tweet_70_seconds_later.text)
      end
      it '終わり時間で検索できる' do
        # メソッド化しても良いかも
        # 作る場合、シリアルナンバー振り直しても良いかも
        tweet_140_seconds_later = create(:tweet, episode_id: episode.id, progress_time_msec: 140 * 1000, tweeted_at: episode.broadcast_datetime.advance(seconds: 140))
        tweet_141_seconds_later = create(:tweet, episode_id: episode.id, progress_time_msec: 141 * 1000, tweeted_at: episode.broadcast_datetime.advance(seconds: 141))
        visit admin_anime_episode_tweets_path(episode.id)
        select 2, from: 'search[end_minutes]'
        select 20, from: 'search[end_seconds]'
        click_on '検索'
        click_link '最後へ', match: :first
        expect(page).to have_content(tweet_140_seconds_later.text)
        expect(page).not_to have_content(tweet_141_seconds_later.text)
      end
      it '検索値がリセットできる' do
        visit admin_anime_episode_tweets_path(episode.id)
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
