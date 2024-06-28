require 'faker'

puts 'Creating an admin user...'
User.create(email: 'admin@admin.com', password: '111111')
puts 'Admin created with credentials: admin@admin.com / 111111'

puts 'Creating fake data...'
users = []
50.times do |counter|
    users << { email: Faker::Internet.email, encrypted_password: Faker::Internet.password }
end
User.insert_all users
puts 'Users generated!'
persons = []
100_000.times do |counter|
    persons << {
        name: Faker::Name.name,
        phone_number: Faker::PhoneNumber.phone_number,
        national_id: CPF.generate,
        active: [true, false].sample,
        user_id: User.pluck(:id).sample,
    }
end
Person.insert_all persons
puts 'Persons generated!'
random_people = Person.pluck(:id)
debts = []
5_000.times do |counter|
    debts << {
        person_id: random_people.sample,
        amount: Faker::Number.between(from: 1, to: 200_000),
        observation: Faker::Lorem.paragraph,
    }
end
Debt.insert_all debts
puts 'Debts generated!'
payments = []
5_000.times do |counter|
    payments << {
        person_id: random_people.sample,
        amount: Faker::Number.between(from: 1, to: 200),
        paid_at: Faker::Date.between(from: 3.months.ago, to: 3.months.since),
    }
end
Payment.insert_all payments
puts 'Payments generated!'

puts 'Fake data successfully created!'
