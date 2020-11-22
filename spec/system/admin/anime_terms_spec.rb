require 'rails_helper'
RSpec.describe 'admin/anime_terms', type: :system do
  describe '放送時期詳細機能(アニメ詳細機能内)' do
    let!(:anime) { create(:anime) }
    let!(:term1) { create(:term, year: 2019, season: 1) }
    let!(:term2) { create(:term, year: 2020, season: 1) }
    let!(:term3) { create(:term, year: 2020, season: 2) }
    before do
      create(:anime_term, anime_id: anime.id, term_id: term1.id)
      create(:anime_term, anime_id: anime.id, term_id: term2.id)
      create(:anime_term, anime_id: anime.id, term_id: term3.id)
    end
    it '表示値が正しい' do
      visit admin_anime_path(anime)
      tds = all('#term-detail tbody tr')
      expect(tds[0]).to have_content(term1.year)
      expect(tds[0]).to have_content(term1.season_ja)
      expect(tds[0]).to have_content(Term.seasons.invert[term1.season])
      expect(tds[1]).to have_content(term2.year)
      expect(tds[1]).to have_content(term2.season_ja)
      expect(tds[1]).to have_content(Term.seasons.invert[term2.season])
      expect(tds[2]).to have_content(term3.year)
      expect(tds[2]).to have_content(term3.season_ja)
      expect(tds[2]).to have_content(Term.seasons.invert[term3.season])
    end
  end
  describe '放送時期編集機能(アニメ詳細機能内)' do
    let!(:anime) { create(:anime) }
    let!(:term1) { create(:term, year: 2019, season: 4) }
    let!(:term2) { create(:term, year: 2020, season: 3) }
    let!(:term3) { create(:term, year: 2020, season: 4) }
    before do
      create(:anime_term, anime_id: anime.id, term_id: term1.id)
      create(:anime_term, anime_id: anime.id, term_id: term2.id)
      create(:anime_term, anime_id: anime.id, term_id: term3.id)
    end
    context '正常処理' do
      it '登録済の放送時期を更新' do
        visit edit_admin_anime_term_path(anime)
        year = 2018
        season = '夏'
        fill_in 'anime_terms_attributes_0_year', with: year
        select season, from: 'anime_terms_attributes_0_season'
        click_on '更新'
        expect(current_path).to eq admin_anime_path(anime)
        tds = all('#term-detail tbody tr')
        expect(tds[0]).to have_content(year)
        expect(tds[0]).to have_content(season)
        expect(tds[1]).to have_content(term2.year)
        expect(tds[1]).to have_content(term2.season_ja)
        expect(tds[2]).to have_content(term3.year)
        expect(tds[2]).to have_content(term3.season_ja)
        expect(tds.length).to eq 3
      end
      it '1行追加で更新できる' do
        visit edit_admin_anime_term_path(anime)
        year = 2021
        season = '秋'
        click_on '1行追加'
        (all('.term-year')[3]).set(year)
        within all('.nested-fields')[3] do
          select season
        end
        click_on '更新'
        expect(current_path).to eq admin_anime_path(anime)
        tds = all('#term-detail tbody tr')
        expect(tds[0]).to have_content(term1.year)
        expect(tds[0]).to have_content(term1.season_ja)
        expect(tds[1]).to have_content(term2.year)
        expect(tds[1]).to have_content(term2.season_ja)
        expect(tds[2]).to have_content(term3.year)
        expect(tds[2]).to have_content(term3.season_ja)
        expect(tds[3]).to have_content(year)
        expect(tds[3]).to have_content(season)
        expect(tds.length).to eq 4
      end
      it '放送時期を削除できる' do
        visit edit_admin_anime_term_path(anime)
        within all('.nested-fields')[0] do
          click_on '削除'
        end
        click_on '更新'
        expect(current_path).to eq admin_anime_path(anime)
        tds = all('#term-detail tbody tr')
        expect(tds[0]).to have_content(term2.year)
        expect(tds[0]).to have_content(term2.season_ja)
        expect(tds[1]).to have_content(term3.year)
        expect(tds[1]).to have_content(term3.season_ja)
        expect(tds.length).to eq 2
      end
    end
    context '特殊処理' do
      it '追加行の年を空欄にしたとき、その行は登録されない' do
        visit edit_admin_anime_term_path(anime)
        click_on '1行追加'
        within all('.nested-fields')[3] do
          select '春'
        end
        click_on '更新'
        expect(current_path).to eq admin_anime_path(anime)
        tds = all('#term-detail tbody tr')
        expect(tds[0]).to have_content(term1.year)
        expect(tds[0]).to have_content(term1.season_ja)
        expect(tds[1]).to have_content(term2.year)
        expect(tds[1]).to have_content(term2.season_ja)
        expect(tds[2]).to have_content(term3.year)
        expect(tds[2]).to have_content(term3.season_ja)
        expect(tds.length).to eq 3
      end
      it '追加行の季節を空欄にしたとき、その行は登録されない' do
        visit edit_admin_anime_term_path(anime)
        click_on '1行追加'
        (all('.term-year')[3]).set(2018)
        click_on '更新'
        expect(current_path).to eq admin_anime_path(anime)
        tds = all('#term-detail tbody tr')
        expect(tds[0]).to have_content(term1.year)
        expect(tds[0]).to have_content(term1.season_ja)
        expect(tds[1]).to have_content(term2.year)
        expect(tds[1]).to have_content(term2.season_ja)
        expect(tds[2]).to have_content(term3.year)
        expect(tds[2]).to have_content(term3.season_ja)
        expect(tds.length).to eq 3
      end
      it '登録済の年を空欄にしたとき、その行は削除される' do
        visit edit_admin_anime_term_path(anime)
        fill_in 'anime_terms_attributes_0_year', with: ''
        click_on '更新'
        expect(current_path).to eq admin_anime_path(anime)
        tds = all('#term-detail tbody tr')
        expect(tds[0]).to have_content(term2.year)
        expect(tds[0]).to have_content(term2.season_ja)
        expect(tds[1]).to have_content(term3.year)
        expect(tds[1]).to have_content(term3.season_ja)
        expect(tds.length).to eq 2
      end
    end
  end
end

