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
  end

  describe 'resource modification' do
    let(:user) { create(:user) }
    let(:empire) { create(:empire, user: user) }

    it 'can add credits' do
      expect { empire.add_credits(100) }.to change { empire.reload.credits }.by(100)
    end
    
    it 'can remove credits' do
      expect { empire.remove_credits(100) }.to change { empire.reload.credits }.by(-100)
    end
    
    it 'prevents credits from going negative' do
      empire.update(credits: 50)
      expect(empire.remove_credits(100)).to be_falsey
      expect(empire.reload.credits).to eq(50)
    end
    
    it 'can add minerals' do
      expect { empire.add_minerals(100) }.to change { empire.reload.minerals }.by(100)
    end
    
    it 'can add energy' do
      expect { empire.add_energy(100) }.to change { empire.reload.energy }.by(100)
    end

    it 'can add population' do
      expect { empire.add_population(100) }.to change { empire.reload.population }.by(100)
    end

    it 'prevents minerals from going negative' do
      empire.update(minerals: 50)
      expect(empire.remove_minerals(100)).to be_falsey
      expect(empire.reload.minerals).to eq(50)
    end
    
    # Similar tests for energy, food, and population
    
    describe 'spend_resources method' do
      before do
        empire.update(credits: 1000, minerals: 500, energy: 500, food: 500, population: 100)
      end
      
      it 'successfully spends resources when available' do
        expect(empire.spend_resources(credits: 100, minerals: 50, energy: 50, food: 50, population: 10)).to be_truthy
        empire.reload
        expect(empire.credits).to eq(900)
        expect(empire.minerals).to eq(450)
        expect(empire.energy).to eq(450)
        expect(empire.food).to eq(450)
        expect(empire.population).to eq(90)
      end
      
      it 'fails to spend resources when not enough available' do
        expect(empire.spend_resources(credits: 1500)).to be_falsey
        expect(empire.reload.credits).to eq(1000)
      end
    end
  end
end
