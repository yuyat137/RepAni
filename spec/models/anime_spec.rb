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
  it 'アニメオブジェクトを削除した時、Term以外の関連オブジェクトは削除される' do
    anime = create(:anime, :associate_all)
    expect(Anime.all.length).to eq 1
    expect(anime.terms.length).not_to eq 0
    expect(anime.episodes.length).not_to eq 0
    expect(anime.episodes.first.tweets).not_to eq 0
    anime.destroy
    expect(Anime.all.length).to be 0
    expect(AnimeTerm.all.length).to be 0
    expect(Episode.all.length).to be 0
    expect(Term.all.length).not_to be 0
  end
end
