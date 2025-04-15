FactoryBot.define do
  factory :star_system do
    name { "System #{Faker::Space.star}" }
    status { "discovered" }
    system_type { "terrestrial" }
    max_population { 1000 }
    max_buildings { 10 }
    current_population { 0 }
    loyalty { 100 }
    
    association :empire, optional: true
  end
end
