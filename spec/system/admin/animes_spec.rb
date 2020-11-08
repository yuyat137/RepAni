require 'rails_helper'
RSpec.describe 'admin/animes', type: :system do
  describe '表示機能' do
    let!(:public_anime) { create(:anime, :associate_term, :public, :episodes) }
    let!(:private_anime) { create(:anime, :associate_term, :private, :episodes) }
    context 'ページを開いた直後' do
      it '登録済の公開状態のアニメが表示されている' do
        visit 'admin/animes'
        within("#anime_#{public_anime.id}") do
          expect(page).to have_content(public_anime.title)
          expect(page).to have_content(public_anime.terms.first.year)
          expect(page).to have_content(public_anime.terms.first.season_ja)
          expect(page).to have_link('非公開にする')
          expect(page).to have_link('削除')
        end
      end
      it '登録済の非公開状態のアニメが表示されている' do
        visit 'admin/animes'
        within("#anime_#{private_anime.id}") do
          expect(page).to have_content(private_anime.title)
          expect(page).to have_content(private_anime.terms.first.year)
          expect(page).to have_content(private_anime.terms.first.season_ja)
          expect(page).to have_link('公開する')
          expect(page).to have_link('削除')
        end
      end
    end
    context 'アニメ操作' do
      it '非公開にする' do
        visit 'admin/animes'
        within("#anime_#{public_anime.id}") do
          click_on '非公開にする'
          expect(page).to have_content('非公開')
          expect(page).to have_link('公開する')
        end
      end
      it '公開する' do
        visit 'admin/animes'
        within("#anime_#{private_anime.id}") do
          click_on '公開する'
          expect(page).to have_content('公開')
          expect(page).to have_link('非公開にする')
        end
      end
    end
  end
  describe '検索機能' do
    let!(:public_anime) { create(:anime, :associate_term, :public, :episodes) }
    let!(:private_anime) { create(:anime, :associate_term, :private, :episodes) }
    before do
      public_anime.update(title: 'ごちうさ')
      public_anime.terms.first.update(year: 2020, season: 1, season_ja: '冬')
      private_anime.update(title: 'きんモザ')
      private_anime.terms.first.update(year: 2019, season: 2, season_ja: '春')
    end
    context 'タイトル検索' do
      it 'タイトルで検索できる' do
        visit 'admin/animes'
        fill_in 'search_title', with: 'ごちうさ'
        click_on '検索'
        expect(page).to have_content(public_anime.title)
        expect(page).not_to have_content(private_anime.title)
      end
      it '一部のタイトルで検索できる' do
        visit 'admin/animes'
        fill_in 'search_title', with: 'うさ'
        click_on '検索'
        expect(page).to have_content(public_anime.title)
        expect(page).not_to have_content(private_anime.title)
      end
      it 'ひらがなカタカナの区別なく検索できる' do
        visit 'admin/animes'
        fill_in 'search_title', with: 'ゴチウサ'
        click_on '検索'
        expect(page).to have_content(public_anime.title)
        expect(page).not_to have_content(private_anime.title)
      end
    end
    context '年で検索' do
      it '年で検索できる' do
        visit 'admin/animes'
        select public_anime.terms.first.year, from: 'search_year'
        click_on '検索'
        expect(page).to have_content(public_anime.title)
        expect(page).not_to have_content(private_anime.title)
      end
    end
    context '季節で検索' do
      it '季節で検索できる' do
        visit 'admin/animes'
        select public_anime.terms.first.season_ja, from: 'search_season'
        click_on '検索'
        expect(page).to have_content(public_anime.title)
        expect(page).not_to have_content(private_anime.title)
      end
    end
    context '公開非公開で検索' do
      it '公開非公開で検索できる' do
        visit 'admin/animes'
        select '公開', from: 'search_public'
        click_on '検索'
        expect(page).to have_content(public_anime.title)
        expect(page).not_to have_content(private_anime.title)
      end
    end
    context '全要素で検索' do
      it '全要素で検索できる' do
        visit 'admin/animes'
        fill_in 'search_title', with: 'ゴチウサ'
        select public_anime.terms.first.year, from: 'search_year'
        select public_anime.terms.first.season_ja, from: 'search_season'
        select '公開', from: 'search_public'
        click_on '検索'
        expect(page).to have_content(public_anime.title)
        expect(page).not_to have_content(private_anime.title)
      end
    end
  end
end
