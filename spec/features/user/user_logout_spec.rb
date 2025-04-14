require 'rails_helper'

RSpec.feature "User Logout", type: :feature do
  let!(:user) { create(:user, username: "testuser", email: "test@example.com", password: "password123") }
  
  scenario "User successfully logs out" do
    # First login
    visit login_path
    fill_in "Email", with: user.email
    fill_in "Password", with: "password123"
    click_button "Log In"
    
    expect(page).to have_content("Welcome, testuser")
    
    # Now log out
    click_link "Log Out"
    
    expect(page).to have_content("Logged out successfully!")
    expect(page).to have_link("Log In")
    expect(page).to have_link("Sign Up")
    expect(page).not_to have_content("Welcome, testuser")
  end
end
