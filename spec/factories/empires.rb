FactoryBot.define do
  factory :empire do
    sequence(:name) { |n| "Empire #{n}" }
    user
    credits { 1000 }
    minerals { 500 }
    energy { 500 }
    food { 500 }
    population { 100 }
  end
end
