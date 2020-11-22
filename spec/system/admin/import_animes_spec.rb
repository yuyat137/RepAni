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
    context '入力値が正しい' do
      it '指定アニメを登録できる' do
        visit admin_import_animes_path
        expect(Anime.all.length).to be 0
        fill_in 'anime_title', with: 'テストアニメ'
        select '2019', from: 'anime_year_1i'
        select '春', from: 'anime_season'
        fill_in 'anime_public_url', with: 'test@example.com'
        fill_in 'anime_default_air_time', with: 25
        fill_in 'anime_twitter_account', with: 'test_account'
        fill_in 'anime_twitter_hash_tag', with: 'test_hash_tag'
        select '非公開', from: 'anime_public'
        fill_in 'anime_episodes_num', with: 13
        find('#register_anime').click
        expect(page).to have_content('アニメを登録しました')
        # TODO: 以下コードは詳細画面ができたら画面から確認する形に移行
        expect(Anime.all.length).to be 1
        anime = Anime.first
        expect(anime.terms.length).to be 1
        expect(anime.episodes.length).to be 13
        expect(anime.title).to eq 'テストアニメ'
        expect(anime.terms.first.year).to eq 2019
        expect(anime.terms.first.season).to eq 'spring'
        expect(anime.public_url).to eq 'test@example.com'
        expect(anime.default_air_time).to be 25
        expect(anime.twitter_account).to eq 'test_account'
        expect(anime.twitter_hash_tag).to eq 'test_hash_tag'
        expect(anime.public).to be false
      end
    end
    context '入力値が誤り' do
      it 'タイトルが無いとアニメが登録できない' do
        visit admin_import_animes_path
        expect(Anime.all.length).to be 0
        select '2019', from: 'anime_year_1i'
        select '春', from: 'anime_season'
        fill_in 'anime_default_air_time', with: 25
        select '非公開', from: 'anime_public'
        fill_in 'anime_episodes_num', with: 13
        find('#register_anime').click
        expect(page).not_to have_content('アニメを登録しました')
      end
      it '放送季節が無いとアニメが登録できない' do
        visit admin_import_animes_path
        expect(Anime.all.length).to be 0
        fill_in 'anime_title', with: 'テストアニメ'
        select '2019', from: 'anime_year_1i'
        fill_in 'anime_default_air_time', with: 25
        select '非公開', from: 'anime_public'
        fill_in 'anime_episodes_num', with: 13
        find('#register_anime').click
        expect(page).not_to have_content('アニメを登録しました')
      end
      it '放送時間が無いとアニメが登録できない' do
        visit admin_import_animes_path
        expect(Anime.all.length).to be 0
        fill_in 'anime_title', with: 'テストアニメ'
        select '2019', from: 'anime_year_1i'
        select '春', from: 'anime_season'
        fill_in 'anime_default_air_time', with: ''
        select '非公開', from: 'anime_public'
        fill_in 'anime_episodes_num', with: 13
        find('#register_anime').click
        expect(page).not_to have_content('アニメを登録しました')
      end
      it '公開非公開が無いとアニメが登録できない' do
        visit admin_import_animes_path
        expect(Anime.all.length).to be 0
        fill_in 'anime_title', with: 'テストアニメ'
        select '2019', from: 'anime_year_1i'
        select '春', from: 'anime_season'
        fill_in 'anime_default_air_time', with: 25
        fill_in 'anime_episodes_num', with: 13
        find('#register_anime').click
        expect(page).not_to have_content('アニメを登録しました')
      end
      it '話数が無いとアニメが登録できない' do
        visit admin_import_animes_path
        expect(Anime.all.length).to be 0
        fill_in 'anime_title', with: 'テストアニメ'
        select '2019', from: 'anime_year_1i'
        select '春', from: 'anime_season'
        fill_in 'anime_default_air_time', with: 25
        select '非公開', from: 'anime_public'
        fill_in 'anime_episodes_num', with: ''
        find('#register_anime').click
        expect(page).not_to have_content('アニメを登録しました')
      end
    end
  end
end
