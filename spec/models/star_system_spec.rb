require 'rails_helper'

RSpec.describe StarSystem, type: :model do
  describe 'validations' do
    it { should validate_presence_of(:name) }
    it { should validate_presence_of(:system_type) }
    it { should validate_numericality_of(:max_population).is_greater_than(0) }
    it { should validate_numericality_of(:max_buildings).is_greater_than(0) }
    it { should validate_numericality_of(:current_population).is_greater_than_or_equal_to(0) }
    it { should validate_numericality_of(:loyalty).is_greater_than_or_equal_to(0).is_less_than_or_equal_to(100) }
  end

  describe 'associations' do
    it { should belong_to(:empire).optional }
    it { should belong_to(:previous_owner).class_name('Empire').optional }
  end

  describe 'system_type enum' do
    it 'should define the correct system types' do
      expect(StarSystem.system_types.keys).to include(
        'terrestrial', 'gas_giant', 'ocean', 'desert', 'tundra', 'asteroid_belt'
      )
    end
  end

  describe '#available_building_slots' do
    let(:star_system) { create(:star_system, max_buildings: 10) }
    
    it 'returns the max_buildings value when building association not yet implemented' do
      expect(star_system.available_building_slots).to eq(10)
    end
  end

  describe 'population limit enforcement' do
    let(:star_system) { create(:star_system, max_population: 1000, current_population: 800) }
    
    it 'allows population within the limit' do
      star_system.current_population = 1000
      expect(star_system).to be_valid
    end
    
    it 'prevents population from exceeding the maximum' do
      star_system.current_population = 1001
      expect(star_system).not_to be_valid
      expect(star_system.errors[:current_population]).to include("cannot exceed maximum population (1000)")
    end
  end

  describe '#population_growth_rate' do
    let(:star_system) { create(:star_system, system_type: 'terrestrial', current_population: 500, max_population: 1000) }
    
    it 'calculates growth rate based on system type and current population' do
      expect(star_system.population_growth_rate).to be_a(Float)
      expect(star_system.population_growth_rate).to be > 0
    end
    
    it 'returns a lower growth rate when approaching maximum population' do
      low_pop_system = create(:star_system, system_type: 'terrestrial', current_population: 100, max_population: 1000)
      high_pop_system = create(:star_system, system_type: 'terrestrial', current_population: 900, max_population: 1000)
      
      expect(low_pop_system.population_growth_rate).to be > high_pop_system.population_growth_rate
    end
    
    it 'returns zero growth rate when at maximum population' do
      full_system = create(:star_system, current_population: 1000, max_population: 1000)
      expect(full_system.population_growth_rate).to eq(0)
    end

    it 'has different base growth rates for different system types' do
      terrestrial_system = create(:star_system, system_type: 'terrestrial', current_population: 500, max_population: 1000)
      desert_system = create(:star_system, system_type: 'desert', current_population: 500, max_population: 1000)
      
      expect(terrestrial_system.population_growth_rate).not_to eq(desert_system.population_growth_rate)
    end
  end
end
