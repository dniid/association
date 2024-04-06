require 'faker'

puts 'Destroying existing records...'
User.destroy_all
Debt.destroy_all
Payment.destroy_all
Person.destroy_all
puts 'Records successfully destroyed!'

puts 'Creating an admin user...'
User.create(email: 'admin@admin.com', password: '111111')
puts 'Admin created with credentials: admin@admin.com / 111111'

puts 'Creating fake data...'
# FactoryBot.create_list(:user, 1000)
50.times do |counter|
    puts "User #{counter}"
    FactoryBot.create(:user)
end
# FactoryBot.create_list(:person, 3000)
3000.times do |counter|
    puts "Person #{counter}"
    FactoryBot.create(:person, user: User.all.sample)
end
# FactoryBot.create_list(:debt, 5000)
5000.times do |counter|
    puts "Debt #{counter}"
    FactoryBot.create(:debt, person: Person.all.sample)
end
# FactoryBot.create_list(:payment, 5000)
5000.times do |counter|
    puts "Payment #{counter}"
    FactoryBot.create(:payment, person: Person.all.sample)
end
puts 'Fake data successfully created!'
