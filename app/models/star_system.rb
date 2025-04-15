class StarSystem < ApplicationRecord
  belongs_to :empire, optional: true
  belongs_to :previous_owner, class_name: 'Empire', optional: true
  has_many :planets
  # Building association will be added when the Building model is implemented
  # has_many :buildings
  
  enum system_type: {
    terrestrial: 'terrestrial',
    gas_giant: 'gas_giant',
    ocean: 'ocean',
    desert: 'desert',
    tundra: 'tundra',
    asteroid_belt: 'asteroid_belt'
  }
  
  validates :name, presence: true
  validates :system_type, presence: true
  validates :max_population, presence: true, numericality: { greater_than: 0 }
  validates :max_buildings, presence: true, numericality: { greater_than: 0 }
  validates :current_population, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :loyalty, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validate :population_cannot_exceed_maximum
  
  # This will be updated when the Building model is implemented
  def available_building_slots
    # For now, just return the maximum since we don't have buildings implemented yet
    max_buildings
  end
  
  def population_growth_rate
    return 0 if current_population >= max_population
    
    base_rates = {
      'terrestrial' => 0.05,
      'ocean' => 0.06,
      'desert' => 0.03,
      'tundra' => 0.02,
      'gas_giant' => 0.01,
      'asteroid_belt' => 0.01
    }
    
    base_rate = base_rates[system_type] || 0.03
    
    # Adjust growth rate based on population density
    population_factor = 1 - (current_population.to_f / max_population)
    
    # Calculate final growth rate
    (base_rate * population_factor).round(4)
  end
  
  private
  
  def population_cannot_exceed_maximum
    if current_population > max_population
      errors.add(:current_population, "cannot exceed maximum population (#{max_population})")
    end
  end
end
