require "faker"

50.times do
    User.create(
        email: Faker::Internet.email,
        password: Faker::Internet.password(min_length: 8),
    )
end

100.times do
    Person.create(
        user: User.all.sample,
        name: Faker::Name.name,
        national_id: Faker::IDNumber.brazilian_citizen_number
    )
end

500.times do
    Debt.create(
        person: Person.all.sample,
        amount: Faker::Number.decimal(l_digits: 2)
    )
end

