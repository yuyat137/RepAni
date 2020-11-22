require 'rails_helper'
RSpec.describe 'admin/import_animes', type: :system do
  describe '今期のアニメ' do
    it '今期アニメが正しく取得できる', vcr: true do
      visit admin_import_animes_path
      expect(Anime.all.length).to be 0
      find('#import_now_term').click
      expect(page).to have_content('ログ欄のアニメをインポートしました')
      expect(Anime.all.length).to be >= 1
      expect(Anime.first.terms.length).to be >= 1
      # 今後実装するか考え中
      # expect(Anime.first.episodes.length).to be >= 1
    end
  end
  describe '指定クールのアニメ' do
    it '指定クールのアニメが正しく取得できる', vcr: true do
      visit admin_import_animes_path
      expect(Anime.all.length).to be 0
      select '2020', from: 'select_term_year'
      select '夏', from: 'select_term_season'
      find('#import_select_term').click
      expect(page).to have_content('ログ欄のアニメをインポートしました')
      expect(page).to have_content('Re:ゼロから始める異世界生活 第2期')
      expect(Anime.all.length).to be 29
      expect(Anime.first.terms.length).to be 1
    end
  end
  describe '指定アニメ登録' do
    let(:title) { Faker::Movie.title }
    let(:public_url) { Faker::Internet.url }
    let(:default_air_time) { Faker::Number.number(digits: 3) }
    let(:twitter_account) { Faker::Twitter.screen_name }
    let(:twitter_hash_tag) { Faker::Lorem.word }
    let(:public) { '非公開' }
    let(:year) { Faker::Time.between_dates(from: Date.today - 5.year, to: Date.today, period: :all).year }
    let(:season) { 'spring' }
    let(:season_ja) { '春' }
    let(:episodes_num) { 13 }
    context '入力値が正しい' do
      it '指定アニメを登録できる' do
        visit admin_import_animes_path
        expect(Anime.all.length).to be 0
        fill_in 'anime_title', with: title
        select year, from: 'anime_year_1i'
        select season_ja, from: 'anime_season'
        fill_in 'anime_public_url', with: public_url
        fill_in 'anime_default_air_time', with: default_air_time
        fill_in 'anime_twitter_account', with: twitter_account
        fill_in 'anime_twitter_hash_tag', with: twitter_hash_tag
        select public, from: 'anime_public'
        fill_in 'anime_episodes_num', with: episodes_num
        find('#register_anime').click
        expect(page).to have_content('アニメを登録しました')
        # TODO: 以下コードは詳細画面ができたら画面から確認する形に移行
        expect(Anime.all.length).to be 1
        anime = Anime.first
        expect(anime.terms.length).to be 1
        expect(anime.episodes.length).to be episodes_num
        expect(anime.title).to eq title
        expect(anime.terms.first.year).to eq year
        expect(anime.terms.first.season).to eq season
        expect(anime.public_url).to eq public_url
        expect(anime.default_air_time).to be default_air_time
        expect(anime.twitter_account).to eq twitter_account
        expect(anime.twitter_hash_tag).to eq twitter_hash_tag
        expect(anime.public).to be false
      end
    end
    context '入力値が誤り' do
      it 'タイトルが無いとアニメが登録できない' do
        visit admin_import_animes_path
        expect(Anime.all.length).to be 0
        select year, from: 'anime_year_1i'
        select season_ja, from: 'anime_season'
        fill_in 'anime_default_air_time', with: default_air_time
        select public, from: 'anime_public'
        fill_in 'anime_episodes_num', with: episodes_num
        find('#register_anime').click
        expect(page).not_to have_content('アニメを登録しました')
      end
      it '放送季節が無いとアニメが登録できない' do
        visit admin_import_animes_path
        expect(Anime.all.length).to be 0
        fill_in 'anime_title', with: title
        select year, from: 'anime_year_1i'
        fill_in 'anime_default_air_time', with: default_air_time
        select public, from: 'anime_public'
        fill_in 'anime_episodes_num', with: episodes_num
        find('#register_anime').click
        expect(page).not_to have_content('アニメを登録しました')
      end
      it '放送時間が無いとアニメが登録できない' do
        visit admin_import_animes_path
        expect(Anime.all.length).to be 0
        fill_in 'anime_title', with: title
        select year, from: 'anime_year_1i'
        select season_ja, from: 'anime_season'
        fill_in 'anime_default_air_time', with: ''
        select public, from: 'anime_public'
        fill_in 'anime_episodes_num', with: episodes_num
        find('#register_anime').click
        expect(page).not_to have_content('アニメを登録しました')
      end
      it '公開非公開が無いとアニメが登録できない' do
        visit admin_import_animes_path
        expect(Anime.all.length).to be 0
        fill_in 'anime_title', with: title
        select year, from: 'anime_year_1i'
        select season_ja, from: 'anime_season'
        fill_in 'anime_default_air_time', with: default_air_time
        fill_in 'anime_episodes_num', with: episodes_num
        find('#register_anime').click
        expect(page).not_to have_content('アニメを登録しました')
      end
      it '話数が無いとアニメが登録できない' do
        visit admin_import_animes_path
        expect(Anime.all.length).to be 0
        fill_in 'anime_title', with: title
        select year, from: 'anime_year_1i'
        select season_ja, from: 'anime_season'
        fill_in 'anime_default_air_time', with: default_air_time
        select public, from: 'anime_public'
        fill_in 'anime_episodes_num', with: ''
        find('#register_anime').click
        expect(page).not_to have_content('アニメを登録しました')
      end
    end
  end
end
