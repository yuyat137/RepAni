require 'rails_helper'
RSpec.describe 'admin/import_animes', type: :system do
  describe '今期のアニメ' do
    let!(:admin_user) { create(:user, role: 'admin') }
    before { admin_login_as(admin_user) }
    xit '今期アニメが正しく取得できる', vcr: true do
      # 季節が変わると、リクエストするURLが変わってしまうためエラーとなる。
      # 他に優先すべき実装があるので、一旦スキップ対応とする
      visit new_admin_animes_import_path
      find('#import_now_term').click
      expect(page).to have_content('ログ欄のアニメをインポートしました')
      expect(Anime.all.length).to be >= 1
      expect(Anime.first.terms.length).to eq 1
    end
  end
  describe '指定クールのアニメ' do
    let!(:admin_user) { create(:user, role: 'admin') }
    before { admin_login_as(admin_user) }
    it '指定クールのアニメが正しく取得できる', vcr: true do
      visit new_admin_animes_import_path
      select '2020', from: 'select_term_year'
      select '夏', from: 'select_term_season'
      find('#import_select_term').click
      expect(page).to have_content('ログ欄のアニメをインポートしました')
      expect(page).to have_content('Re:ゼロから始める異世界生活 第2期')
      expect(Anime.all.length).to be 29
      expect(Anime.first.terms.first.year).to eq 2020
      expect(Anime.first.terms.first.season).to eq 'summer'
      expect(Anime.first.terms.first.season_ja).to eq '夏'
    end
  end
end
