require 'rails_helper'
RSpec.describe 'admin/users', type: :system do
  describe '一覧表示機能' do
    let!(:admin_user) { create(:user, role: 'admin') }
    let!(:general_user) { create(:user, role: 'general') }
    before { admin_login_as(admin_user) }
    it '一覧にユーザーが表示される' do
      visit admin_users_path
      within('#users_list') do
        expect(page).to have_content(admin_user.name)
        expect(page).to have_content(admin_user.email)
        expect(page).to have_content('管理者')
        expect(page).to have_content(general_user.name)
        expect(page).to have_content(general_user.email)
        expect(page).to have_content('一般')
      end
    end
    it '一覧からユーザーを削除できる' do
      visit admin_users_path
      trs = all('#users_list tbody tr')
      expect(trs.length).to eq 2
      within trs[1] do
        click_link '削除'
        page.driver.browser.switch_to.alert.accept
      end
      trs = all('#users_list tbody tr')
      expect(trs.length).to eq 1
    end
  end
  describe '新規登録機能' do
    let!(:admin_user) { create(:user, role: 'admin') }
    let(:name) { Faker::Name.name }
    let(:email) { Faker::Internet.email }
    let(:role) { '一般' }
    before { admin_login_as(admin_user) }
    context 'ユーザー登録成功' do
      it 'ユーザーを新規作成できる' do
        visit new_admin_user_path
        fill_in '名前', with: name
        fill_in 'メールアドレス', with: email
        fill_in 'パスワード', with: 'password'
        fill_in 'パスワード(確認)', with: 'password'
        select role, from: 'user_role'
        click_on '登録'
        within('#users_list') do
          expect(page).to have_content(name)
          expect(page).to have_content(email)
          expect(page).to have_content(role)
        end
        trs = all('#users_list tbody tr')
        expect(trs.length).to eq 2
      end
    end
    context 'ユーザー登録失敗' do
      it '名前を書かないとエラー' do
        visit new_admin_user_path
        fill_in 'メールアドレス', with: email
        fill_in 'パスワード', with: 'password'
        fill_in 'パスワード(確認)', with: 'password'
        select role, from: 'user_role'
        click_on '登録'
        expect(page).to have_content('ユーザーの作成に失敗しました')
        expect(page).to have_content('名前を入力してください')
        expect(User.all.length).to eq 1
      end
      it 'メールアドレスを書かないとエラー' do
        visit new_admin_user_path
        fill_in '名前', with: name
        fill_in 'パスワード', with: 'password'
        fill_in 'パスワード(確認)', with: 'password'
        select role, from: 'user_role'
        click_on '登録'
        expect(page).to have_content('ユーザーの作成に失敗しました')
        expect(page).to have_content('メールアドレスを入力してください')
        expect(User.all.length).to eq 1
      end
      it 'パスワードを書かないとエラー' do
        visit new_admin_user_path
        fill_in '名前', with: name
        fill_in 'メールアドレス', with: email
        select role, from: 'user_role'
        click_on '登録'
        expect(page).to have_content('パスワードは3文字以上で入力してください')
        expect(page).to have_content('パスワード(確認)を入力してください')
        expect(User.all.length).to eq 1
      end
      it 'パスワードが一致しないとエラー' do
        visit new_admin_user_path
        fill_in '名前', with: name
        fill_in 'メールアドレス', with: email
        fill_in 'パスワード', with: 'password'
        fill_in 'パスワード(確認)', with: 'Password'
        select role, from: 'user_role'
        click_on '登録'
        expect(page).to have_content('パスワード(確認)とパスワードの入力が一致しません')
        expect(User.all.length).to eq 1
      end
    end
  end
  describe '編集機能' do
    let!(:admin_user1) { create(:user, role: 'admin') }
    let!(:admin_user2) { create(:user, role: 'admin') }
    let(:name) { Faker::Name.name }
    let(:email) { Faker::Internet.email }
    let(:role) { '一般' }
    before { admin_login_as(admin_user1) }
    context 'ユーザー更新成功' do
      it 'ユーザーを更新できる' do
        visit admin_users_path
        trs = all('#users_list tbody tr')
        within('#users_list') do
          click_link admin_user2.name
        end
        fill_in '名前', with: name
        fill_in 'メールアドレス', with: email
        select role, from: 'user_role'
        click_on '更新'
        expect(page).to have_content('ユーザーを更新しました')
        trs = all('#users_list tbody tr')
        within trs[1] do
          expect(page).to have_content(name)
          expect(page).to have_content(email)
          expect(page).to have_content(role)
        end
      end
    end
    context 'ユーザー更新失敗' do
      it '名前を書かないとエラー' do
        visit edit_admin_user_path(admin_user2)
        fill_in '名前', with: ''
        fill_in 'メールアドレス', with: email
        select role, from: 'user_role'
        click_on '更新'
        expect(page).to have_content('ユーザーの更新に失敗しました')
        expect(page).to have_content('名前を入力してください')
      end
      it 'メールアドレスを書かないとエラー' do
        visit edit_admin_user_path(admin_user2)
        fill_in '名前', with: name
        fill_in 'メールアドレス', with: ''
        select role, from: 'user_role'
        click_on '更新'
        expect(page).to have_content('ユーザーの更新に失敗しました')
        expect(page).to have_content('メールアドレスを入力してください')
      end
      it '重複したメールアドレスを書くとエラー' do
        visit edit_admin_user_path(admin_user2)
        fill_in 'メールアドレス', with: admin_user1.email
        click_on '更新'
        expect(page).to have_content('ユーザーの更新に失敗しました')
        expect(page).to have_content('メールアドレスはすでに存在します')
      end
    end
  end
end
