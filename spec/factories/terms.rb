FactoryBot.define do
  factory :term do
    year { DateTime.now.year }
    season { (DateTime.now.month - 1) / 3 + 1 }
    season_ja { 'テストシーズン' }
  end
end
