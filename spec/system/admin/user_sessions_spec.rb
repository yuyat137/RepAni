require 'rails_helper'
RSpec.describe 'admin/user_sessions', type: :system do
  describe 'ログイン機能' do
    let!(:admin_user) { create(:user, role: 'admin') }
    let!(:general_user) { create(:user, role: 'general') }
    context 'ログインできる' do
      it '管理者でログインできる' do
        visit admin_login_path
        fill_in 'メールアドレス', with: admin_user.email
        fill_in 'パスワード', with: 'password'
        click_button 'ログイン'
        expect(page).to have_content('ログインしました')
        expect(current_path).to eq admin_root_path
      end
    end
    context 'ログインできない' do
      it '管理者でメールアドレスが異なるとログインできない' do
        visit admin_login_path
        fill_in 'メールアドレス', with: 'miss@example.com'
        fill_in 'パスワード', with: 'password'
        click_button 'ログイン'
        expect(page).to have_content('ログインに失敗しました')
        expect(current_path).to eq admin_login_path
      end
      it '管理者でパスワードが異なるとログインできない' do
        visit admin_login_path
        fill_in 'メールアドレス', with: admin_user.email
        fill_in 'パスワード', with: 'miss'
        click_button 'ログイン'
        expect(page).to have_content('ログインに失敗しました')
        expect(current_path).to eq admin_login_path
      end
      it '一般ユーザーでログインできない' do
        visit admin_login_path
        fill_in 'メールアドレス', with: general_user.email
        fill_in 'パスワード', with: 'password'
        click_button 'ログイン'
        expect(page).to have_content('権限がありません')
        expect(current_path).to eq root_path
      end
    end
  end
  describe 'ログアウト機能' do
    let!(:admin_user) { create(:user, role: 'admin') }
    before { admin_login_as(admin_user) }
    it 'ログアウトできる' do
      visit admin_root_path
      click_on 'ログアウト'
      expect(page).to have_content('ログアウトしました')
      expect(current_path).to eq root_path
    end
  end
  describe 'ログイン制御' do
    let!(:general_user) { create(:user, role: 'general') }
    it 'アニメ管理ページに遷移するとログインが要求される' do
      visit admin_animes_path
      expect(page).to have_content('ログインしてください')
      expect(current_path).to eq admin_login_path
    end
    it 'アニメインポートページに遷移するとログインが要求される' do
      visit new_admin_animes_import_path
      expect(page).to have_content('ログインしてください')
      expect(current_path).to eq admin_login_path
    end
    it 'ユーザー管理ページに遷移するとログインが要求される' do
      visit admin_users_path
      expect(page).to have_content('ログインしてください')
      expect(current_path).to eq admin_login_path
    end
  end
end
