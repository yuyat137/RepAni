require 'rails_helper'
RSpec.describe 'Anime', type: :system do
  let!(:anime_now) { create(:anime, :with_now_term, public: true) }
  let!(:anime_not_now) { create(:anime, :with_term, public: true) }
  let!(:anime_public) { create(:anime, :with_now_term, public: true) }
  let!(:anime_private) { create(:anime, :with_now_term, public: false) }
  let!(:anime_with_episodes) { create(:anime, :with_episodes, :with_now_term, public: true) }
  context 'アニメ表示画面' do
    it '最初は今期アニメ情報が表示されている' do
      visit '/anime'
      expect(page).to have_content(anime_now.title)
      expect(page).not_to have_content(anime_not_now.title)
    end
    it '公開中のアニメのみ表示される' do
      visit '/anime'
      expect(page).to have_content(anime_public.title)
      expect(page).not_to have_content(anime_private.title)
    end
    it '選択した期間のアニメ情報が表示される' do
      visit '/anime'
      find("#term_#{anime_not_now.terms.first.id}").click
      expect(page).to have_content(anime_not_now.title)
      expect(page).not_to have_content(anime_now.title)
    end
    it '選択したアニメのエピソードの話数とサブタイトルが表示される' do
      visit '/anime'
      find("#term_#{anime_with_episodes.terms.first.id}").click
      find("#anime_#{anime_with_episodes.id}").click
      episode1 = anime_with_episodes.episodes.first
      expect(page).to have_content("#{episode1.num}話 『#{episode1.subtitle}』")
    end
    it '選択したアニメのエピソードが全て表示される' do
      visit '/anime'
      find("#term_#{anime_with_episodes.terms.first.id}").click
      find("#anime_#{anime_with_episodes.id}").click
      trs = all('#episodes_list tr')
      expect(trs.length).to eq anime_with_episodes.episodes.length
    end
  end
end

