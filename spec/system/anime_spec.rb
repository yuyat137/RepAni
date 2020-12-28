require 'rails_helper'
RSpec.describe 'Anime', type: :system do
  let!(:anime_now) { create(:anime, :with_now_term, public: true) }
  let!(:anime_not_now) { create(:anime, :with_term, public: true) }
  let!(:anime_public) { create(:anime, :with_now_term, public: true) }
  let!(:anime_private) { create(:anime, :with_now_term, public: false) }
  context 'アニメ表示画面' do
    it '今期アニメ情報が画面に表示されている' do
      visit '/anime'
      expect(page).to have_content(anime_now.title)
      expect(page).not_to have_content(anime_not_now.title)
    end
    it '公開中のアニメのみ表示される' do
      visit '/anime'
      expect(page).to have_content(anime_public.title)
      expect(page).not_to have_content(anime_private.title)
    end
  end
  context 'アニメ期間を選択' do
    it '選択した期間のアニメ情報が画面に表示されている' do
      visit '/anime'
      find("#term_#{anime_not_now.terms.first.id}").click
      expect(page).to have_content(anime_not_now.title)
      expect(page).not_to have_content(anime_now.title)
    end
  end
  context 'エピソード表示ダイアログ' do
    before do
      create(:episode, anime_id: anime_public.id, num: 1, public: true)
      create(:episode, anime_id: anime_public.id, num: 2, public: false)
    end
    it '公開中のエピソードのみ表示される' do
      visit '/anime'
      find("#anime_#{anime_public.id}").click
      expect(page).to have_content anime_public.title
      expect(page).to have_link '1話'
      expect(page).not_to have_link '2話'
    end
  end
end

