require 'rails_helper'

RSpec.describe Tweet, type: :model do
  it 'エピソードIDがないと無効' do
    tweet = build(:tweet, episode_id:'')
    tweet.valid?
    expect(tweet.errors[:episode_id]).to include('を入力してください')
  end
  it 'ツイートIDがないと無効' do
    tweet = build(:tweet, tweet_id:'')
    tweet.valid?
    expect(tweet.errors[:tweet_id]).to include('を入力してください')
  end
  it '経過時間がないと無効' do
    tweet = build(:tweet, progress_time_msec:'')
    tweet.valid?
    expect(tweet.errors[:progress_time_msec]).to include('を入力してください')
  end
  it '連番がないと無効' do
    tweet = build(:tweet, serial_number:'')
    tweet.valid?
    expect(tweet.errors[:serial_number]).to include('を入力してください')
  end
  it '名前がないと無効' do
    tweet = build(:tweet, name:'')
    tweet.valid?
    expect(tweet.errors[:name]).to include('を入力してください')
  end
  it 'screen_nameがないと無効' do
    tweet = build(:tweet, screen_name:'')
    tweet.valid?
    expect(tweet.errors[:screen_name]).to include('を入力してください')
  end
  it 'プロフィール画像がないと無効' do
    tweet = build(:tweet, profile_image_url:'')
    tweet.valid?
    expect(tweet.errors[:profile_image_url]).to include('を入力してください')
  end
  it 'テキストがないと無効' do
    tweet = build(:tweet, text:'')
    tweet.valid?
    expect(tweet.errors[:text]).to include('を入力してください')
  end
  it 'ツイート日時がないと無効' do
    tweet = build(:tweet, tweeted_at:'')
    tweet.valid?
    expect(tweet.errors[:tweeted_at]).to include('を入力してください')
  end
  it 'ツイートIDが重複していると無効' do
    tweet1 = create(:tweet)
    tweet2 = build(:tweet, tweet_id:tweet1.tweet_id )
    tweet2.valid?
    expect(tweet2.errors[:tweet_id]).to include('はすでに存在します')
  end
end
