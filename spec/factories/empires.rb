# spec/factories/empires.rb
FactoryBot.define do
  factory :empire do
    name { "Empire of #{Faker::Space.galaxy}" }
    credits { 1000 }
    minerals { 500 }
    energy { 200 }
    food { 300 }
    population { 100 }
    association :user
  end
end
