FactoryBot.define do
  factory :star_system do
    name { "System #{Faker::Space.star}" }
    status { "discovered" }
    system_type { "terrestrial" }
    max_population { 1000 }
    max_buildings { 10 }
    current_population { 0 }
    loyalty { 100 }
    
    # Empire association is nil by default (matches optional: true in model)
    empire { nil }
  end
end
