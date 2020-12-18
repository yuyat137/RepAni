require 'rails_helper'

RSpec.describe Term, type: :model do
  it '年がないと無効' do
    term = build(:term, year:'')
    term.valid?
    expect(term.errors[:year]).to include('を入力してください')
  end
  it '季節がないと無効' do
    term = build(:term, season:'')
    term.valid?
    expect(term.errors[:season]).to include('を入力してください')
  end
  it 'nowがないと無効' do
    term = build(:term, now:'')
    term.valid?
    expect(term.errors[:now]).to include('は一覧にありません')
  end
  it '年と季節の組み合わせが重複していると無効' do
    create(:term, year: 2020, season: 3)
    term = build(:term, year: 2020, season: 3)
    term.valid?
    expect(term.errors[:season]).to include('はすでに存在します')
  end
  it '季節(日本語)は自動的にセットされる' do
    term1 = create(:term, season: 'winter')
    term2 = create(:term, season: 'spring')
    term3 = create(:term, season: 'summer')
    term4 = create(:term, season: 'autumn')
    expect(term1.season_ja).to eq '冬'
    expect(term2.season_ja).to eq '春'
    expect(term3.season_ja).to eq '夏'
    expect(term4.season_ja).to eq '秋'
  end
end
