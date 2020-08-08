require 'rails_helper'
RSpec.describe 'Anime', type: :system do
  let!(:anime) { create(:anime) }
  it 'アニメ情報が画面に表示されている' do
    visit '/anime'
    expect(page).to have_content(anime.title)
  end
end

