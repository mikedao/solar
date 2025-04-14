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
end
