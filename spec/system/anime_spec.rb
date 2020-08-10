require 'rails_helper'
RSpec.describe 'Anime', type: :system do
  let!(:anime1) { create(:anime, :associate_term) }
  let!(:anime2) { create(:anime, :associate_term) }
  context 'ページを開いた直後' do
    before { anime1.terms.first.update(now: true) }
    it '今期アニメ情報が画面に表示されている' do
      visit '/anime'
      expect(page).to have_content(anime1.title)
      expect(page).not_to have_content(anime2.title)
    end
  end
  context 'アニメ期間を選択' do
    before { anime1.terms.first.update(now: true) }
    it '選択した期間のアニメ情報が画面に表示されている' do
      visit '/anime'
      find("#term_#{anime2.terms.first.id}").click
      expect(page).to have_content(anime2.title)
      expect(page).not_to have_content(anime1.title)
    end
  end
end

