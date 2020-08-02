require 'rails_helper'
RSpec.describe 'トップ画面', type: :system do
  it 'タイトル表示がある' do
    visit root_path
    expect(page).to have_content('test')
  end
  it 'ログインボタンがある' do
    visit root_path
    expect(page).to have_content('test')
  end
end

