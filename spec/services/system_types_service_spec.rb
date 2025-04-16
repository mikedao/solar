require 'rails_helper'

RSpec.describe SystemTypesService do
  describe 'SYSTEM_TYPES constant' do
    it 'defines all required system types' do
      expect(SystemTypesService::SYSTEM_TYPES.keys).to include(
        :terrestrial, :ocean, :desert, :tundra, :gas_giant, :asteroid_belt
      )
    end
    
    it 'includes necessary attributes for each system type' do
      SystemTypesService::SYSTEM_TYPES.each do |_, attributes|
        expect(attributes).to have_key(:weight)
        expect(attributes).to have_key(:population_range)
        expect(attributes).to have_key(:buildings_range)
        expect(attributes).to have_key(:description)
      end
    end
  end

  describe '.description_for' do
    it 'returns the correct description for a system type' do
      description = SystemTypesService.description_for(:gas_giant)
      expect(description).to eq(SystemTypesService::SYSTEM_TYPES[:gas_giant][:description])
    end
  
    it 'returns a default message for unknown system types' do
      description = SystemTypesService.description_for(:invalid_type)
      expect(description).to eq("Unknown system type.")
    end
  end

  describe '.attribute_ranges_for' do
    it 'returns the correct ranges for a given system type' do
      ranges = SystemTypesService.attribute_ranges_for(:desert)
      expect(ranges).to eq(SystemTypesService::SYSTEM_TYPES[:desert])
    end
  
    it 'returns terrestrial ranges for an unknown system type' do
      ranges = SystemTypesService.attribute_ranges_for(:unknown)
      expect(ranges).to eq(SystemTypesService::SYSTEM_TYPES[:terrestrial])
    end
  end

  describe '.generate_random_type' do
    it 'returns a valid system type' do
      type = SystemTypesService.generate_random_type
      expect(SystemTypesService::SYSTEM_TYPES.keys).to include(type)
    end
  
    it 'generates a distribution of system types over many trials' do
      results = Hash.new(0)
      
      1000.times do
        type = SystemTypesService.generate_random_type
        results[type] += 1
      end
      
      # Check that each type appears at least once
      expect(results.keys).to match_array(SystemTypesService::SYSTEM_TYPES.keys)
      
      # Check that higher weighted types appear more frequently
      expect(results[:terrestrial]).to be > results[:ocean]
      expect(results[:ocean]).to be > results[:desert]
      expect(results[:ocean]).to be > results[:tundra]
      expect(results[:desert]).to be > results[:gas_giant]
      expect(results[:tundra]).to be > results[:gas_giant]
      expect(results[:gas_giant]).to be > results[:asteroid_belt]
    end

    it 'returns terrestrial as fallback when random selection fails' do
      total_weight = SystemTypesService::SYSTEM_TYPES.sum do |_, attributes| 
        attributes[:weight] 
      end
      
      # Stub rand to return a value equal to the total weight 
      
      # This forces the method to hit the fallback case
      allow(SystemTypesService).to receive(:rand).and_return(total_weight)
      
      expect(SystemTypesService.generate_random_type).to eq(:terrestrial)
    end
  end

  describe '.generate_attributes_for' do
    it 'generates attributes within the specified ranges' do
      attributes = SystemTypesService.generate_attributes_for(:ocean)
      
      pop_range = SystemTypesService::SYSTEM_TYPES[:ocean][:population_range]
      building_range = SystemTypesService::SYSTEM_TYPES[:ocean][:buildings_range]
      
      expect(attributes[:max_population]).to be_between(pop_range[0], pop_range[1])
      expect(attributes[:max_buildings]).to be_between(building_range[0], building_range[1])
      expect(attributes[:description]).to eq(SystemTypesService::SYSTEM_TYPES[:ocean][:description])
    end
  end
end
