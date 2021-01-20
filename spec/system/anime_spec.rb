require 'rails_helper'
RSpec.describe 'Anime', type: :system do
  describe '放送時期' do
    let!(:current_anime) { create(:anime, :with_now_term, public: true) }
    let!(:past_anime) { create(:anime, :with_term, public: true) }
    before { create_list(:term, 5) }
    context '初期表示' do
      it '初期表示は今期が選択されている' do
        visit '/anime'
        expect(page).to have_content(current_anime.title)
        expect(page).not_to have_content(past_anime.title)
      end
    end
    context '表示内容' do
      it '全ての放送時期が表示される' do
        visit '/anime'
        trs = all('#terms_list tr')
        expect(trs.length).to eq Episode.all.length
      end
    end
  end
  describe 'アニメ表示' do
    let!(:public_anime) { create(:anime, :with_now_term, public: true) }
    let!(:private_anime) { create(:anime, :with_now_term, public: false) }
    let!(:term) { create(:term) }
    before do
      animes = create_list(:anime, 10)
      animes.each { |anime| create(:anime_term, anime_id: anime.id, term_id: term.id) }
    end
    it '公開中のアニメのみ表示される' do
      visit '/anime'
      expect(page).to have_content(public_anime.title)
      expect(page).not_to have_content(private_anime.title)
    end
    it '該当時期のアニメ全てが表示される' do
      visit '/anime'
      find("#term_#{term.id}").click
      trs = all('#animes_list tr')
      expect(trs.length).to eq term.animes.length
    end
  end
  describe 'エピソード表示' do
    let(:anime) { create(:anime, :with_term, public: true) }
    let!(:public_episode) { create(:episode, anime_id: anime.id, public: true) }
    let!(:private_episode) { create(:episode, anime_id: anime.id, public: false) }
    context 'エピソード表示' do
      it '選択したアニメのエピソードの話数とサブタイトルが表示される' do
        visit '/anime'
        find("#term_#{anime.terms.first.id}").click
        find("#anime_#{anime.id}").click
        expect(page).to have_content("#{public_episode.num}話 『#{public_episode.subtitle}』")
      end
      it '公開中のエピソードのみ表示される' do
        visit '/anime'
        find("#term_#{anime.terms.first.id}").click
        find("#anime_#{anime.id}").click
        expect(page).to have_content(public_episode.subtitle)
        expect(page).not_to have_content(private_episode.subtitle)
      end
    end
  end
end

