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
end
