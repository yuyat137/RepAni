require 'rails_helper'

RSpec.describe Term, type: :model do
  # 季節(日本語)についてはbefore_validateフックで作成してるためテストしない
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
end
