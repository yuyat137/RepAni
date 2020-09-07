require 'rails_helper'
RSpec.describe 'Anime', type: :system do
  let!(:anime) { create(:anime, :associate_now_term, :episodes) }
  let!(:episode) { anime.episodes.first }
  let!(:tweets) { create_list(:tweet, 20, episode_id: episode.id) }
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
