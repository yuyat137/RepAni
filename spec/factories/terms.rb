FactoryBot.define do
  factory :term do
    sequence(:year) { |n| 2000 + n }
    sequence(:season) { |n| (n % 4) + 1 }
    season_ja { 'テストシーズン' }
    now { false }
  end
  trait :now_true do
    after(:create) do |term|
      year ||= Date.today.year
      season ||= (Date.today.month - 1) / 3 + 1
      Term.find_by(year: year, season: season)&.destroy
      term.update(year: year, season: season, now: true)
    end
  end
end
