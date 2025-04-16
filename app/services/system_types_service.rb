# app/services/system_types_service.rb
class SystemTypesService
  SYSTEM_TYPES = {
    terrestrial: {
      weight: 35,
      population_range: [800, 1200],
      buildings_range: [8, 12],
      description: "Earth-like worlds with diverse climates and resources."
    },
    ocean: {
      weight: 20,
      population_range: [1000, 1500],
      buildings_range: [6, 10],
      description: "Water-covered worlds ideal for large populations but with limited building space."
    },
    desert: {
      weight: 15,
      population_range: [400, 800],
      buildings_range: [10, 14],
      description: "Arid worlds with harsh conditions but abundant mineral resources."
    },
    tundra: {
      weight: 15,
      population_range: [500, 900],
      buildings_range: [7, 11],
      description: "Cold worlds with moderate habitability but rich in unique resources."
    },
    gas_giant: {
      weight: 10,
      population_range: [200, 500],
      buildings_range: [12, 16],
      description: "Massive gas planets with abundant energy sources and orbital habitats."
    },
    asteroid_belt: {
      weight: 5,
      population_range: [100, 300],
      buildings_range: [14, 20],
      description: "Dense clusters of asteroids with extensive mining opportunities."
    }
  }

  def self.description_for(system_type)
    SYSTEM_TYPES.dig(system_type.to_sym, :description) || "Unknown system type."
  end

  def self.attribute_ranges_for(system_type)
    SYSTEM_TYPES[system_type.to_sym] || SYSTEM_TYPES[:terrestrial]
  end

  def self.generate_random_type
    total_weight = SYSTEM_TYPES.sum { |_, attributes| attributes[:weight] }
    random_value = rand(total_weight)
    
    cumulative_weight = 0
    SYSTEM_TYPES.each do |type, attributes|
      cumulative_weight += attributes[:weight]
      return type if random_value < cumulative_weight
    end
    
    # Fallback (should never reach here unless weights are misconfigured)
    :terrestrial
  end

  def self.generate_attributes_for(system_type)
    ranges = attribute_ranges_for(system_type)
    
    {
      max_population: rand(ranges[:population_range][0]..ranges[:population_range][1]),
      max_buildings: rand(ranges[:buildings_range][0]..ranges[:buildings_range][1]),
      description: ranges[:description]
    }
  end

  def self.generate_system_attributes
    type = generate_random_type
    attributes = generate_attributes_for(type)
    attributes.merge(system_type: type)
  end
end
