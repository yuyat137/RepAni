require 'rails_helper'

RSpec.describe Anime, type: :model do
  it 'タイトルがないと無効' do
    anime = build(:anime, title:'')
    anime.valid?
    expect(anime.errors[:title]).to include('を入力してください')
  end
  it 'タイトルが重複していると無効' do
    create(:anime, title:'test')
    anime = build(:anime, title:'test')
    anime.valid?
    expect(anime.errors[:title]).to include('はすでに存在します')
  end
end
