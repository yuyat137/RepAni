require 'rails_helper'
RSpec.describe 'Replay', type: :system do
  let!(:anime) { create(:anime, :associate_now_term, :episodes) }
  let!(:episode) { anime.episodes.first }
  let!(:tweet1) { create(:tweet, episode_id: episode.id, serial_number: 1) }
  let!(:tweet2) { create(:tweet, episode_id: episode.id, serial_number: 2) }

  describe 'タイマー' do
    context 'ページを開いたら' do
      it 'タイマーの初期表示がある' do
        visit "/replay/#{episode.id}"
        expect(page).to have_content("00:00:00/00:#{anime.default_air_time}:00")
      end
      it 'タイマーが動く' do
        visit "/replay/#{episode.id}"
        find("#timer_start").click
        sleep(1)
        expect(page).not_to have_content("00:00:00/00:#{anime.default_air_time}:00")
        expect(page).not_to have_content("START")
        expect(page).to have_content("STOP")
      end
    end
  end
  describe 'ツイート表示' do
    context 'ページを開いたら' do
      it 'タイトルと話数が表示される' do
        visit "/replay/#{episode.id}"
        expect(page).to have_content(anime.title)
        expect(page).to have_content("#{episode.num}話")
      end
      it 'ツイートが表示される' do
        visit "/replay/#{episode.id}"
        find("#timer_start").click
        sleep(1)
        expect(page).to have_content(tweet1.text)
        sleep(1)
        expect(page).to have_content(tweet2.text)
      end
    end
  end
end
