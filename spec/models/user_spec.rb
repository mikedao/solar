require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    subject { create(:user) }
    
    it { should validate_presence_of(:username) }
    it { should validate_uniqueness_of(:username) }
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }
    it { should validate_presence_of(:password) }
    it { should validate_length_of(:password).is_at_least(8) }
  end

  describe 'username format' do
    it 'allows valid usernames' do
      user = build(:user, username: 'valid_username123')
      expect(user).to be_valid
    end

    it 'rejects invalid usernames' do
      user = build(:user, username: 'invalid username!')
      expect(user).not_to be_valid
    end
  end
end
