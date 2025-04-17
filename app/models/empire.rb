class Empire < ApplicationRecord
  belongs_to :user
  has_many :star_systems
  
  validates :name, presence: true, length: { minimum: 3, maximum: 50 }
  validates :credits, :minerals, :energy, :food, :population, 
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :user_id, presence: true, uniqueness: true

  after_create :create_starting_system
  
  private
  
    def create_starting_system
      StarSystem.create!(
        name: "#{name} Prime",
        system_type: "terrestrial",
        max_population: 1000,
        max_buildings: 10,
        current_population: 100,
        loyalty: 100,
        status: "discovered",
        empire: self
      )
    end
end
