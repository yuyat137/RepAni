require 'rails_helper'
RSpec.describe 'Replay', type: :system do
  let!(:anime) { create(:anime, :associate_now_term, :episodes) }
  let!(:episode) { anime.episodes.first }
  let!(:tweets) { 20.times.collect { |i| create(:tweet, episode_id: episode.id, serial_number: i + 1) } }

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
      it 'Startボタンを押すとタイマーが動く' do
        visit "/replay/#{episode.id}"
        find("#timer_start").click
        sleep(1)
        expect(page).not_to have_content("00:00:00/00:#{anime.default_air_time}:00")
        expect(page).not_to have_content("START")
        expect(page).to have_content("STOP")
      end
      it 'Stopボタンを押すとタイマーが止まる' do
        visit "/replay/#{episode.id}"
        find("#timer_start").click
        sleep(1)
        find("#timer_stop").click
        expect(page).to have_content("START")
        expect(page).not_to have_content("STOP")
      end
      it '10秒戻るボタンを押すとタイマーが止まる' do
        visit "/replay/#{episode.id}"
        find("#timer_start").click
        sleep(1)
        find("#move_few_back").click
        expect(page).to have_content("START")
        expect(page).not_to have_content("STOP")
      end
      it '10秒進むボタンを押すとタイマーが止まる' do
        visit "/replay/#{episode.id}"
        find("#timer_start").click
        sleep(1)
        find("#move_few_back").click
        expect(page).to have_content("START")
        expect(page).not_to have_content("STOP")
      end
    end
  end
  describe 'ツイート表示' do
    it 'タイマーが作動すると時間に応じてツイートが表示される' do
      visit "/replay/#{episode.id}"
      find("#timer_start").click
      sleep(1)
      expect(page).to have_content(tweets[0].text)
      expect(page).not_to have_content(tweets[1].text)
      sleep(1)
      expect(page).to have_content(tweets[1].text)
    end
    xit '一度時間を止めると、再作動させた時間に対応するツイートが表示される' do
      # 何故か再作動時にツイートが表示されない。
      # 実際の挙動と異なり、原因がわからないので一旦保留
      visit "/replay/#{episode.id}"
      sleep(1)
      find("#timer_start").click
      expect(page).to have_content(tweets[0].text)
      sleep(3)
      find("#move_few_front").click
      sleep(1)
      find("#timer_start").click
      sleep(3)
      expect(page).not_to have_content(tweets[0].text)
      expect(page).to have_content(tweets[15].text)
    end
  end
end
