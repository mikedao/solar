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
end
