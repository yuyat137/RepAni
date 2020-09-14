require 'rails_helper'
RSpec.describe 'Replay', type: :system do
  let!(:anime) { create(:anime, :associate_now_term, :episodes) }
  let!(:episode) { anime.episodes.first }
  let!(:tweets) { create_list(:tweet, 20, episode_id: episode.id) }
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
        # TODO: このコードは本番とは動きが異なる。
        visit "/replay/#{episode.id}"
        find("#timer_start").click
        expect(page).to have_content(tweets[0].text)
        expect(page).to have_content(tweets[1].text)
      end
    end
  end
end
