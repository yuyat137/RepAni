FactoryBot.define do
  factory :term do
    sequence(:year) { |n| 2000 + n }
    sequence(:season) { |n| (n % 4) + 1 }
    season_ja { 'テストシーズン' }
    now { false }
  end
  trait :now_true do
    after(:create) do |term|
      term.update(now: true)
    end
  end
end
