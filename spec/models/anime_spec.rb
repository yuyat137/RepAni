require 'rails_helper'

RSpec.describe Anime, type: :model do
  it 'タイトルがないと無効' do
    anime = build(:anime, title:'')
    anime.valid?
    expect(anime.errors).to be_added(:title, :blank)
  end
end
