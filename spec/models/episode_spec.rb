require 'rails_helper'

RSpec.describe Episode, type: :model do
  it '話数がないと無効' do
    episode = build(:episode, num:'')
    episode.valid?
    expect(episode.errors[:num]).to include('を入力してください')
  end
  it '放送時刻がないと無効' do
    episode = build(:episode, broadcast_datetime:'')
    episode.valid?
    expect(episode.errors[:broadcast_datetime]).to include('を入力してください')
  end
  it '放送時間がないと無効' do
    episode = build(:episode, air_time:'')
    episode.valid?
    expect(episode.errors[:air_time]).to include('を入力してください')
  end
  it '公開非公開の指定がないと非公開になる' do
    episode = create(:episode, public:'')
    expect(episode.public).to be_falsey
  end
  it 'アニメと話数の組が重複していると無効' do
    episode1 = create(:episode)
    episode2 = build(:episode, anime_id: episode1.anime.id, num: episode1.num)
    episode2.valid?
    expect(episode2.errors[:num]).to include('はすでに存在します')
  end
  it 'エピソードを削除すると関連するツイートも削除' do
    anime = create(:anime, :with_all)
    expect(anime.episodes.first.tweets.length).not_to eq 0
    anime.episodes.first.destroy
    expect(Tweet.all.length).to eq 0
  end
end
