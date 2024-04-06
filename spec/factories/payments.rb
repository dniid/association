FactoryBot.define do
  factory :payment do
    person
    amount { Faker::Number.between(from: 1, to: 200) }
    paid_at { Faker::Date.between(from: 3.months.ago, to: 3.months.since) }
  end
end
