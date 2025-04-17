require 'rails_helper'

RSpec.describe Empire, type: :model do
  describe 'validations' do
    let(:user) { create(:user) }
    subject { build(:empire, user: user) }
    
    it { should validate_presence_of(:name) }
    it { should validate_length_of(:name).is_at_least(3).is_at_most(50) }
    
    it { should validate_numericality_of(:credits).only_integer.is_greater_than_or_equal_to(0) }
    it { should validate_numericality_of(:minerals).only_integer.is_greater_than_or_equal_to(0) }
    it { should validate_numericality_of(:energy).only_integer.is_greater_than_or_equal_to(0) }
    it { should validate_numericality_of(:food).only_integer.is_greater_than_or_equal_to(0) }
    it { should validate_numericality_of(:population).only_integer.is_greater_than_or_equal_to(0) }
    
    it { should validate_presence_of(:user_id) }
    it { should validate_uniqueness_of(:user_id) }
  end
  
  describe 'associations' do
    it { should belong_to(:user) }
    it { should have_many(:star_systems) }
  end

  # spec/models/empire_spec.rb - Add to the existing file

  describe 'callbacks' do
    describe 'after_create' do
      it 'creates a starting star system' do
        user = create(:user)
        empire = create(:empire, user: user, name: "Galactic Republic")
        
        expect(empire.star_systems.count).to eq(1)
        
        system = empire.star_systems.first
        expect(system.name).to eq("Galactic Republic Prime")
        expect(system.system_type).to eq("terrestrial")
        expect(system.max_population).to eq(1000)
        expect(system.max_buildings).to eq(10)
        expect(system.current_population).to eq(100)
        expect(system.loyalty).to eq(100)
        expect(system.status).to eq("discovered")
      end
    end
  end
end
