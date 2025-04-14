class Empire < ApplicationRecord
  belongs_to :user
  
  validates :name, presence: true, length: { minimum: 3, maximum: 50 }
  validates :credits, :minerals, :energy, :food, :population, 
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :user_id, presence: true, uniqueness: true

  # Prevent negative resources (unless override is specified)
  validate :resources_cannot_be_negative
  
  # Helper methods for modifying resources
  def add_credits(amount)
    update_resource(:credits, amount)
  end
  
  def remove_credits(amount)
    update_resource(:credits, -amount)
  end
  
  def add_minerals(amount)
    update_resource(:minerals, amount)
  end
  
  def remove_minerals(amount)
    update_resource(:minerals, -amount)
  end
  
  def add_energy(amount)
    update_resource(:energy, amount)
  end
  
  def remove_energy(amount)
    update_resource(:energy, -amount)
  end
  
  def add_food(amount)
    update_resource(:food, amount)
  end
  
  def remove_food(amount)
    update_resource(:food, -amount)
  end
  
  def add_population(amount)
    update_resource(:population, amount)
  end
  
  def remove_population(amount)
    update_resource(:population, -amount)
  end
  
  # Generic resource update method that raises an error if would go negative
  def update_resource(resource, amount, allow_negative = false)
    new_value = self[resource] + amount
    
    if new_value < 0 && !allow_negative
      return false
    end
    
    update("#{resource}" => new_value)
  end
  
  # Attempt to spend resources, returns true if successful, false otherwise
  def spend_resources(credits: 0, minerals: 0, energy: 0, food: 0, population: 0)
    return false if credits > self.credits ||
                    minerals > self.minerals ||
                    energy > self.energy ||
                    food > self.food ||
                    population > self.population

    ActiveRecord::Base.transaction do
      remove_credits(credits) if credits > 0
      remove_minerals(minerals) if minerals > 0
      remove_energy(energy) if energy > 0
      remove_food(food) if food > 0
      remove_population(population) if population > 0
    end

    true
  end
  
  private
  
  def resources_cannot_be_negative
    [:credits, :minerals, :energy, :food, :population].each do |resource|
      if self[resource] && self[resource] < 0
        errors.add(resource, "cannot be negative")
      end
    end
  end
end
