FactoryBot.define do
  factory :debt do
    person
    amount { Faker::Number.between(from: 1, to: 200) }
    observation { Faker::Lorem.paragraph }
  end
end
