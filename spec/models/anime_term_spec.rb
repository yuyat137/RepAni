require 'rails_helper'

RSpec.describe Anime, type: :model do
  it 'anime_idがないと無効' do
    term = create(:term)
    anime_term = build(:anime_term, term_id: term.id)
    anime_term.valid?
    expect(anime_term.errors[:anime_id]).to include('を入力してください')
  end
  it 'term_idがないと無効' do
    anime = create(:anime)
    anime_term = build(:anime_term, anime_id: anime.id)
    anime_term.valid?
    expect(anime_term.errors[:term_id]).to include('を入力してください')
  end
  it 'anime_idとterm_idの組み合わせが重複してると無効' do
    anime = create(:anime)
    term = create(:term)
    create(:anime_term, anime_id: anime.id, term_id: term.id)
    anime_term = build(:anime_term, anime_id: anime.id, term_id: term.id)
    anime_term.valid?
    expect(anime_term.errors[:anime_id]).to include('はすでに存在します')
  end
end
