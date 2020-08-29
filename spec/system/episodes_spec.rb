require 'rails_helper'
RSpec.describe 'Episodes', type: :system do
  let!(:anime1) { create(:anime, :associate_now_term, :episodes) }
  let!(:anime2) { create(:anime, :associate_term, :episodes) }
  context 'アニメを選択する' do
    it 'エピソード選択画面が表示される' do
      visit '/anime'
      find("#anime_#{anime1.id}").click
      expect(page).to have_content("サブタイトルを選んでください")
      expect(page).to have_link '1'
    end
  end
end

