require 'rails_helper'
RSpec.describe 'Replay', type: :system do
  let!(:anime) { create(:anime, :with_now_term, :with_episodes) }
  let!(:episode) { anime.episodes.first }
  let!(:tweets) { 20.times.collect { |i| create(:tweet, episode_id: episode.id, serial_number: i + 1, progress_time_msec: i * 1000, tweeted_at: episode.broadcast_datetime.advance(seconds: i)) }}
  describe 'アニメ情報' do
    context 'ページを開いたら' do
      it 'タイトルと話数が表示される' do
        visit "/replay/#{episode.id}"
        expect(page).to have_content(anime.title)
        expect(page).to have_content("#{episode.num}話")
      end
    end
  end
  describe 'タイマー' do
    context 'ページを開いたら' do
      it 'タイマーの初期表示がある' do
        visit "/replay/#{episode.id}"
        expect(page).to have_content("00:00:00/00:#{anime.default_air_time}:00")
      end
      it 'スタートボタンを押すとタイマーが動く' do
        visit "/replay/#{episode.id}"
        find("#timer_start").click
        sleep(1)
        expect(page).not_to have_content("00:00:00/00:#{anime.default_air_time}:00")
        expect(page).not_to have_content("スタート")
        expect(page).to have_content("ストップ")
      end
      it 'Stopボタンを押すとタイマーが止まる' do
        visit "/replay/#{episode.id}"
        find("#timer_start").click
        sleep(1)
        find("#timer_stop").click
        expect(page).to have_content("スタート")
        expect(page).not_to have_content("ストップ")
      end
      it '10秒戻るボタンを押すとタイマーが止まる' do
        visit "/replay/#{episode.id}"
        find("#timer_start").click
        sleep(1)
        find("#move_few_back").click
        expect(page).to have_content("スタート")
        expect(page).not_to have_content("ストップ")
      end
      it '10秒進むボタンを押すとタイマーが止まる' do
        visit "/replay/#{episode.id}"
        find("#timer_start").click
        sleep(1)
        find("#move_few_back").click
        expect(page).to have_content("スタート")
        expect(page).not_to have_content("ストップ")
      end
    end
  end
  describe 'ツイート表示' do
    it 'タイマーが作動すると時間に応じてツイートが表示される' do
      visit "/replay/#{episode.id}"
      find("#timer_start").click
      expect(page).to have_content(tweets[0].text)
      expect(page).not_to have_content(tweets[1].text)
      sleep(1)
      expect(page).to have_content(tweets[1].text)
    end
    it '一度時間を止めると、再作動させた時間に対応するツイートが表示される' do
      visit "/replay/#{episode.id}"
      find("#timer_start").click
      expect(page).to have_content(tweets[0].text)
      find("#move_few_front").click
      sleep(2)
      find("#timer_start").click
      expect(page).not_to have_content(tweets[0].text)
      expect(page).to have_content(tweets[11].text)
    end
  end
end
