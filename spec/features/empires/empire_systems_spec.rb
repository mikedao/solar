require 'rails_helper'

RSpec.feature "Empire Systems Display", type: :feature do
  let(:user) { create(:user) }
  let!(:empire) { create(:empire, user: user) }
  # The empire should already have a starting system from the after_create callback
  
  scenario "User views their systems on the empire page" do
    login_as(user)
    visit empire_path(empire)
    
    expect(page).to have_content("Systems")
    
    within(".systems-section") do
      system = empire.star_systems.first
      expect(page).to have_content(system.name)
      expect(page).to have_content("Terrestrial")
      expect(page).to have_content("100/1000") # Population
      expect(page).to have_content("0/10") # Used buildings
    end
  end
  
  scenario "User can navigate to system details" do
    login_as(user)
    visit empire_path(empire)
    
    system = empire.star_systems.first
    click_link system.name
    
    expect(current_path).to eq(star_system_path(system))
  end
end
