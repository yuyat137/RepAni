require 'rails_helper'
RSpec.describe 'admin/animes', type: :system do
  describe '一覧表示機能' do
    let!(:public_anime) { create(:anime, :with_term, :with_episodes, public: true) }
    let!(:private_anime) { create(:anime, :with_term, :with_episodes, public: false) }
    let!(:admin_user) { create(:user, role: 'admin') }
    before { admin_login_as(admin_user) }
    context 'ページを開いた直後' do
      it '登録済の公開状態のアニメが表示されている' do
        visit admin_animes_path
        within("#anime_#{public_anime.id}") do
          expect(page).to have_content(public_anime.title)
          expect(page).to have_content(public_anime.terms.first.year)
          expect(page).to have_content(public_anime.terms.first.season_ja)
          expect(page).to have_link('非公開にする')
        end
      end
      it '登録済の非公開状態のアニメが表示されている' do
        visit admin_animes_path
        within("#anime_#{private_anime.id}") do
          expect(page).to have_content(private_anime.title)
          expect(page).to have_content(private_anime.terms.first.year)
          expect(page).to have_content(private_anime.terms.first.season_ja)
          expect(page).to have_link('公開する')
        end
      end
    end
    context 'アニメ操作' do
      it '非公開にする' do
        visit admin_animes_path
        within("#anime_#{public_anime.id}") do
          click_on '非公開にする'
          expect(page).to have_content('非公開')
          expect(page).to have_link('公開する')
        end
      end
      it '公開する' do
        visit admin_animes_path
        within("#anime_#{private_anime.id}") do
          click_on '公開する'
          expect(page).to have_content('公開')
          expect(page).to have_link('非公開にする')
        end
      end
    end
  end
  describe '検索機能' do
    let!(:public_anime) { create(:anime, :with_term, :with_episodes, title: 'ごちうさ', public: true) }
    let!(:private_anime) { create(:anime, :with_term, :with_episodes, title: 'きんモザ', public: false) }
    let!(:admin_user) { create(:user, role: 'admin') }
    before do
      public_anime.terms.first.update(year: 2020, season: 1, season_ja: '冬')
      private_anime.terms.first.update(year: 2019, season: 2, season_ja: '春')
      admin_login_as(admin_user)
    end
    context 'タイトル検索' do
      it 'タイトルで検索できる' do
        visit admin_animes_path
        fill_in 'search_title', with: 'ごちうさ'
        click_on '検索'
        expect(page).to have_content(public_anime.title)
        expect(page).not_to have_content(private_anime.title)
      end
      it '一部のタイトルで検索できる' do
        visit admin_animes_path
        fill_in 'search_title', with: 'うさ'
        click_on '検索'
        expect(page).to have_content(public_anime.title)
        expect(page).not_to have_content(private_anime.title)
      end
      it 'ひらがなカタカナの区別なく検索できる' do
        visit admin_animes_path
        fill_in 'search_title', with: 'ゴチウサ'
        click_on '検索'
        expect(page).to have_content(public_anime.title)
        expect(page).not_to have_content(private_anime.title)
      end
    end
    context '年で検索' do
      it '年で検索できる' do
        visit admin_animes_path
        select public_anime.terms.first.year, from: 'search_year'
        click_on '検索'
        expect(page).to have_content(public_anime.title)
        expect(page).not_to have_content(private_anime.title)
      end
    end
    context '季節で検索' do
      it '季節で検索できる' do
        visit admin_animes_path
        select public_anime.terms.first.season_ja, from: 'search_season'
        click_on '検索'
        expect(page).to have_content(public_anime.title)
        expect(page).not_to have_content(private_anime.title)
      end
    end
    context '公開非公開で検索' do
      it '公開非公開で検索できる' do
        visit admin_animes_path
        select '公開', from: 'search_public'
        click_on '検索'
        expect(page).to have_content(public_anime.title)
        expect(page).not_to have_content(private_anime.title)
      end
    end
    context '全要素で検索' do
      it '全要素で検索できる' do
        visit admin_animes_path
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
  describe 'アニメ新規作成' do
    let!(:admin_user) { create(:user, role: 'admin') }
    before { admin_login_as(admin_user) }
    context '入力値が正しい' do
      it '指定アニメを登録できる' do
        title = Faker::Movie.title
        year = Faker::Time.between_dates(from: Date.today - 5.year, to: Date.today, period: :all).year
        season = '春'
        public_url = Faker::Internet.url
        default_air_time = Faker::Number.number(digits: 3)
        twitter_account = Faker::Twitter.screen_name
        twitter_hash_tag = Faker::Lorem.word
        first_broadcast_datetime = DateTime.now

        visit new_admin_anime_path
        fill_in 'anime_title', with: title
        select year, from: 'anime_year_1i'
        select season, from: 'anime_season'
        fill_in 'anime_public_url', with: public_url
        fill_in 'anime_default_air_time', with: default_air_time
        fill_in 'anime_twitter_account', with: twitter_account
        fill_in 'anime_twitter_hash_tag', with: twitter_hash_tag
        find('#anime_first_broadcast_datetime').set(first_broadcast_datetime)
        select '非公開', from: 'anime_public'
        click_on '登録'
        expect(page).to have_content('アニメを登録しました')
        click_on title
        expect(page).to have_content(title)
        expect(page).to have_content(season)
        expect(page).to have_content(public_url)
        expect(page).to have_content(default_air_time)
        expect(page).to have_content(first_broadcast_datetime.strftime('%Y-%m-%d %H:%M'))
        expect(page).to have_content(default_air_time)
        expect(page).to have_content(twitter_account)
        expect(page).to have_content(twitter_hash_tag)
        expect(page).to have_content('false')
      end
    end
    context '入力値が誤り' do
      it 'タイトルが無いとアニメが登録できない' do
        visit new_admin_anime_path
        fill_in 'anime_title', with: ''
        select 2020, from: 'anime_year_1i'
        select '春', from: 'anime_season'
        fill_in 'anime_default_air_time', with: 30
        select '非公開', from: 'anime_public'
        click_on '登録'
        expect(page).not_to have_content('アニメを登録しました')
      end
      it '放送季節が無いとアニメが登録できない' do
        visit new_admin_anime_path
        fill_in 'anime_title', with: 'title'
        select 2020, from: 'anime_year_1i'
        select '', from: 'anime_season'
        fill_in 'anime_default_air_time', with: 30
        select '非公開', from: 'anime_public'
        click_on '登録'
        expect(page).not_to have_content('アニメを登録しました')
      end
      it '放送時間が無いとアニメが登録できない' do
        visit new_admin_anime_path
        fill_in 'anime_title', with: 'title'
        select 2020, from: 'anime_year_1i'
        select '春', from: 'anime_season'
        fill_in 'anime_default_air_time', with: ''
        select '非公開', from: 'anime_public'
        click_on '登録'
        expect(page).not_to have_content('アニメを登録しました')
      end
      it '公開非公開が無いとアニメが登録できない' do
        visit new_admin_anime_path
        fill_in 'anime_title', with: 'title'
        select 2020, from: 'anime_year_1i'
        select '春', from: 'anime_season'
        fill_in 'anime_default_air_time', with: 30
        select '', from: 'anime_public'
        click_on '登録'
        expect(page).not_to have_content('アニメを登録しました')
      end
    end
  end
  describe '詳細機能' do
    let!(:anime) { create(:anime) }
    let!(:admin_user) { create(:user, role: 'admin') }
    before { admin_login_as(admin_user) }
    it '初期表示が正しい' do
      visit admin_anime_path(anime)
      within('#anime_id') { expect(page).to have_content(anime.id) }
      within('#anime_title') { expect(page).to have_content(anime.title) }
      within('#anime_public_url') { expect(page).to have_content(anime.public_url) }
      within('#anime_default_air_time') { expect(page).to have_content(anime.default_air_time) }
      within('#anime_twitter_account') { expect(page).to have_content(anime.twitter_account) }
      within('#anime_twitter_hash_tag') { expect(page).to have_content(anime.twitter_hash_tag) }
      within('#anime_public') { expect(page).to have_content(anime.public) }
    end
  end
  describe '編集機能' do
    let!(:anime) { create(:anime, public: true) }
    let!(:admin_user) { create(:user, role: 'admin') }
    before { admin_login_as(admin_user) }
    context '更新できる場合' do
      it 'アニメ情報を編集更新できる' do
        title = Faker::Movie.title
        public_url = Faker::Internet.url
        default_air_time = Faker::Number.number(digits: 3)
        twitter_account = Faker::Twitter.screen_name
        twitter_hash_tag = Faker::Lorem.word
        public = '非公開'

        visit edit_admin_anime_path(anime)
        fill_in 'anime_title', with: title
        fill_in 'anime_public_url', with: public_url
        fill_in 'anime_default_air_time', with: default_air_time
        fill_in 'anime_twitter_account', with: twitter_account
        fill_in 'anime_twitter_hash_tag', with: twitter_hash_tag
        select public, from: 'anime_public'
        click_on '登録'
        expect(page).to have_content('登録情報を更新しました')
        expect(page).to have_content(title)
        expect(page).to have_content(public_url)
        expect(page).to have_content(default_air_time)
        expect(page).to have_content(twitter_account)
        expect(page).to have_content(twitter_hash_tag)
        expect(page).to have_content(public)
      end
    end
    context '更新できない場合' do
      it 'タイトルがない場合更新できない' do
        visit edit_admin_anime_path(anime)
        fill_in 'anime_title', with: ''
        fill_in 'anime_public_url', with: 'public_url'
        fill_in 'anime_default_air_time', with: 30
        fill_in 'anime_twitter_account', with: 'twitter_account'
        fill_in 'anime_twitter_hash_tag', with: 'twitter_hash_tag'
        select '非公開', from: 'anime_public'
        click_on '登録'
        expect(page).not_to have_content('登録情報を更新しました')
      end
      it '放送時間(分)がない場合更新できない' do
        visit edit_admin_anime_path(anime)
        fill_in 'anime_title', with: 'title'
        fill_in 'anime_public_url', with: 'public_url'
        fill_in 'anime_default_air_time', with: ''
        fill_in 'anime_twitter_account', with: 'twitter_account'
        fill_in 'anime_twitter_hash_tag', with: 'twitter_hash_tag'
        select '非公開', from: 'anime_public'
        click_on '登録'
        expect(page).not_to have_content('登録情報を更新しました')
      end
      it '公開非公開がない場合更新できない' do
        visit edit_admin_anime_path(anime)
        fill_in 'anime_title', with: 'title'
        fill_in 'anime_public_url', with: 'public_url'
        fill_in 'anime_default_air_time', with: 30
        fill_in 'anime_twitter_account', with: 'twitter_account'
        fill_in 'anime_twitter_hash_tag', with: 'twitter_hash_tag'
        select '', from: 'anime_public'
        click_on '登録'
        expect(page).not_to have_content('登録情報を更新しました')
      end
    end
  end
end
