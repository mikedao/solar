require 'rails_helper'

RSpec.feature "Empire Resources Management", type: :feature do
  let(:user) { create(:user) }
  let!(:empire) { create(:empire, user: user, credits: 1000, minerals: 500, energy: 500, food: 500, population: 100) }
  
  context "when not logged in" do
    scenario "redirects to login page when trying to view empire" do
      visit empire_path(empire)
      
      expect(current_path).to eq(login_path)
      expect(page).to have_content("You must be logged in to access this page")
    end
  end
  
  context "when logged in" do
    before do
      visit login_path
      fill_in "Email", with: user.email
      fill_in "Password", with: "password123"
      click_button "Log In"
    end
    
    scenario "displays empire resources" do
      visit empire_path(empire)
      
      expect(page).to have_content(empire.name)
      expect(page).to have_content("Credits: 1000")
      expect(page).to have_content("Minerals: 500")
      expect(page).to have_content("Energy: 500")
      expect(page).to have_content("Food: 500")
      expect(page).to have_content("Population: 100")
    end
    
    scenario "allows adding resources" do
      visit empire_path(empire)
      
      select "Credits", from: "Resource"
      select "Add", from: "Action"
      fill_in "Amount", with: 200
      
      click_button "Update Resources"
      
      expect(page).to have_content("Resources updated successfully!")
      expect(page).to have_content("Credits: 1200")
    end
    
    scenario "allows removing resources when enough are available" do
      visit empire_path(empire)
      
      select "Minerals", from: "Resource"
      select "Remove", from: "Action"
      fill_in "Amount", with: 100
      
      click_button "Update Resources"
      
      expect(page).to have_content("Resources updated successfully!")
      expect(page).to have_content("Minerals: 400")
    end
    
    scenario "prevents removing more resources than available" do
      visit empire_path(empire)
      
      select "Energy", from: "Resource"
      select "Remove", from: "Action"
      fill_in "Amount", with: 1000
      
      click_button "Update Resources"
      
      # We should still be redirected with a notice, but the value won't change
      expect(page).to have_content("Resources updated successfully!")
      expect(page).to have_content("Energy: 500") # Value remains unchanged
    end
    
    scenario "allows removing population when enough is available" do
      visit empire_path(empire)
      
      select "Population", from: "Resource"
      select "Remove", from: "Action"
      fill_in "Amount", with: 25
      
      click_button "Update Resources"
      
      expect(page).to have_content("Resources updated successfully!")
      expect(page).to have_content("Population: 75")
    end
    
    scenario "allows adding food resources" do
      visit empire_path(empire)
      
      select "Food", from: "Resource"
      select "Add", from: "Action"
      fill_in "Amount", with: 150
      
      click_button "Update Resources"
      
      expect(page).to have_content("Resources updated successfully!")
      expect(page).to have_content("Food: 650")
    end
  end
end
