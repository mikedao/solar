require 'rails_helper'

RSpec.feature "Empire Creation With System", type: :feature do
  let(:user) { create(:user) }
  
  before do
    # Clear any empire created by factory callbacks
    user.empire&.destroy
  end
  
  scenario "User creates an empire and automatically gets a starting system" do
    # Log in
    visit login_path
    fill_in "Email", with: user.email
    fill_in "Password", with: "password123"
    click_button "Log In"
    
    # Navigate to empire creation
    visit new_empire_path
    
    # Create empire
    fill_in "Empire Name", with: "Test Empire"
    click_button "Create Empire"
    
    # Verify empire was created
    expect(page).to have_content("Empire successfully created")
    expect(page).to have_content("Test Empire")
    
    # Verify a system was created
    expect(page).to have_content("Systems")
    within(".systems-section") do
      expect(page).to have_content("Test Empire Prime")
      expect(page).to have_content("Terrestrial")
      expect(page).to have_content("100/1000") # Population
    end
    
    # Verify in the database
    empire = user.reload.empire
    expect(empire.star_systems.count).to eq(1)
    
    system = empire.star_systems.first
    expect(system.name).to eq("Test Empire Prime")
    expect(system.system_type).to eq("terrestrial")
  end
end
