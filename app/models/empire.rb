class Empire < ApplicationRecord
  belongs_to :user
  
  validates :name, presence: true, length: { minimum: 3, maximum: 50 }
  validates :credits, :minerals, :energy, :food, :population, 
            numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :user_id, presence: true, uniqueness: true
end
