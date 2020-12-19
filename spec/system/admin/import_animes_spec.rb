require 'rails_helper'
RSpec.describe 'admin/import_animes', type: :system do
  describe '今期のアニメ' do
    let!(:admin_user) { create(:user, role: 'admin') }
    before { admin_login_as(admin_user) }
    it '今期アニメが正しく取得できる', vcr: true do
      visit new_admin_animes_import_path
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
    let!(:admin_user) { create(:user, role: 'admin') }
    before { admin_login_as(admin_user) }
    it '指定クールのアニメが正しく取得できる', vcr: true do
      visit new_admin_animes_import_path
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
end
