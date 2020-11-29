require 'rails_helper'

RSpec.describe Episode, type: :model do
  it '話数がないと無効' do
    episode = build(:episode, num:'')
    episode.valid?
    expect(episode.errors[:num]).to include('を入力してください')
  end
  it '放送時間がないと無効' do
    episode = build(:episode, air_time:'')
    episode.valid?
    expect(episode.errors[:air_time]).to include('を入力してください')
  end
  it 'publicがないと無効' do
    episode = build(:episode, public:'')
    episode.valid?
    expect(episode.errors[:public]).to include('は一覧にありません')
  end
  it 'アニメと話数の組が重複していると無効' do
    episode1 = create(:episode)
    episode2 = build(:episode, anime_id: episode1.anime.id, num: episode1.num)
    episode2.valid?
    expect(episode2.errors[:num]).to include('はすでに存在します')
  end
  it 'エピソードを削除すると関連するツイートも削除' do
    anime = create(:anime, :episodes)
    create(:tweet, episode: anime.episodes.first)
    expect(anime.episodes.first.tweets.length).to eq 1
    anime.episodes.first.destroy
    expect(Tweet.all.length).to eq 0
  end
end
