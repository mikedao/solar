# spec/features/empire_management_spec.rb
require 'rails_helper'

RSpec.feature "Empire Management", type: :feature do
  let(:user) { create(:user, username: "testuser", email: "test@example.com", password: "password123") }
  
  scenario "User creates a new empire after registration" do
    visit signup_path
    
    fill_in "Username", with: "newuser"
    fill_in "Email", with: "newuser@example.com"
    fill_in "Password", with: "password123"
    fill_in "Password confirmation", with: "password123"
    click_button "Sign Up"
    
    expect(page).to have_current_path(new_empire_path)
    expect(page).to have_content("Account created successfully! Now create your empire.")
    
    fill_in "Empire Name", with: "New Test Empire"
    click_button "Create Empire"
    
    expect(page).to have_content("Empire successfully created")
    expect(page).to have_content("New Test Empire")
    expect(page).to have_content("Credits")
    expect(page).to have_content("1000") # Default credits
  end
  
  scenario "User can't create an empire without being logged in" do
    visit new_empire_path
    
    expect(page).to have_current_path(login_path)
    expect(page).to have_content("You must be logged in to access this page")
  end
  
  scenario "User can't create a second empire" do
    create(:empire, name: "First Empire", user: user)
    
    login_as(user)
    visit new_empire_path
    
    expect(page).to have_current_path(empire_path(user.empire))
    expect(page).to have_content("You already have an empire")
  end
  
  scenario "User views their empire details" do
    empire = create(:empire, name: "Test Empire", user: user, 
                   credits: 2000, minerals: 1000, energy: 500, food: 800, population: 200)
    
    login_as(user)
    visit empire_path(empire)
    
    expect(page).to have_content("Test Empire")
    expect(page).to have_content("Welcome, testuser")
    expect(page).to have_content("Credits")
    expect(page).to have_content("2000")
    expect(page).to have_content("Minerals")
    expect(page).to have_content("1000")
    expect(page).to have_content("Energy")
    expect(page).to have_content("500")
    expect(page).to have_content("Food")
    expect(page).to have_content("800")
    expect(page).to have_content("Population")
    expect(page).to have_content("200")
  end
  
  scenario "User can't view another user's empire" do
    other_user = create(:user)
    other_empire = create(:empire, user: other_user)
    
    login_as(user)
    visit empire_path(other_empire)
    
    expect(page).to have_current_path(root_path)
    expect(page).to have_content("You can only manage your own empire")
  end
  
  scenario "User updates their empire name" do
    empire = create(:empire, name: "Old Empire Name", user: user)
    
    login_as(user)
    visit edit_empire_path(empire)
    
    fill_in "Empire Name", with: "New Empire Name"
    click_button "Update Empire"
    
    expect(page).to have_current_path(empire_path(empire))
    expect(page).to have_content("Empire successfully updated")
    expect(page).to have_content("New Empire Name")
  end
  
  scenario "User can't update their empire with invalid data" do
    empire = create(:empire, name: "Test Empire", user: user)
    
    login_as(user)
    visit edit_empire_path(empire)
    
    fill_in "Empire Name", with: ""
    click_button "Update Empire"
    
    expect(page).to have_content("The following errors prevented updating your empire")
    expect(page).to have_content("Name can't be blank")
  end
  
  scenario "User can't edit another user's empire" do
    other_user = create(:user)
    other_empire = create(:empire, user: other_user)
    
    login_as(user)
    visit edit_empire_path(other_empire)
    
    expect(page).to have_current_path(root_path)
    expect(page).to have_content("You can only manage your own empire")
  end

  scenario "User tries to create an empire with invalid data" do
    # First create and log in as a user
    user = create(:user, username: "testuser", email: "test@example.com", password: "password123")
    
    visit login_path
    fill_in "Email", with: "test@example.com"
    fill_in "Password", with: "password123"
    click_button "Log In"
    
    # Navigate to the empire creation page
    visit new_empire_path
    
    # Submit the form with empty empire name (which is invalid)
    fill_in "Empire Name", with: ""
    click_button "Create Empire"
    
    # Expect to stay on the same page with validation errors
    expect(page).to have_current_path(/empires$/)
    expect(page).to have_content("The following errors prevented creating your empire")
    expect(page).to have_content("Name can't be blank")
    
    # Make sure no empire was created
    expect(user.reload.empire).to be_nil
    
    # Try again with a too-short name (assuming min length is 3)
    fill_in "Empire Name", with: "AB"
    click_button "Create Empire"
    
    expect(page).to have_content("Name is too short")
    expect(user.reload.empire).to be_nil
    
    # Finally create a valid empire to confirm we can proceed
    fill_in "Empire Name", with: "Valid Empire Name"
    click_button "Create Empire"
    
    expect(page).to have_content("Empire successfully created")
    expect(page).to have_content("Valid Empire Name")
    expect(user.reload.empire).to be_present
  end
  
  # Helper method to login
  def login_as(user)
    visit login_path
    fill_in "Email", with: user.email
    fill_in "Password", with: "password123"
    click_button "Log In"
  end
end
