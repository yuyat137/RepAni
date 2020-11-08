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
  it 'アニメオブジェクトを削除した時、関連オブジェクトも削除される' do
    Anime.register({title: 'テスト', year: 2020, season: 2, default_air_time: 30, public: true, episodes_num: 12})
    expect(Anime.all.length).to eq 1
    anime = Anime.first
    expect(anime.terms.length).to be 1
    expect(anime.episodes.length).to be 12
    anime.destroy
    expect(Anime.all.length).to be 0
    expect(AnimeTerm.all.length).to be 0
    expect(Episode.all.length).to be 0
  end
end
