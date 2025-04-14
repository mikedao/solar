require 'rails_helper'

RSpec.feature "User Signup", type: :feature do
  scenario "User successfully signs up with valid information" do
    visit signup_path
    
    fill_in "Username", with: "testuser"
    fill_in "Email", with: "test@example.com"
    fill_in "Password", with: "password123"
    fill_in "Password confirmation", with: "password123"
    
    click_button "Sign Up"
    
    expect(page).to have_content("Account created successfully!")
    expect(page).to have_content("Welcome, testuser")
    expect(current_path).to eq(root_path)
  end
  
  scenario "User fails to sign up with invalid information" do
    visit signup_path
    
    # Empty form submission
    click_button "Sign Up"
    
    expect(page).to have_content("The following errors prevented signing up:")
    expect(page).to have_content("Username can't be blank")
    expect(page).to have_content("Email can't be blank")
    expect(page).to have_content("Password can't be blank")
  end
  
  scenario "User fails to sign up with mismatched passwords" do
    visit signup_path
    
    fill_in "Username", with: "testuser"
    fill_in "Email", with: "test@example.com"
    fill_in "Password", with: "password123"
    fill_in "Password confirmation", with: "different123"
    
    click_button "Sign Up"
    
    expect(page).to have_content("Password confirmation doesn't match Password")
  end
  
  scenario "User fails to sign up with invalid email format" do
    visit signup_path
    
    fill_in "Username", with: "testuser"
    fill_in "Email", with: "invalidemail"
    fill_in "Password", with: "password123"
    fill_in "Password confirmation", with: "password123"
    
    click_button "Sign Up"
    
    expect(page).to have_content("Email is invalid")
  end
  
  scenario "User fails to sign up with invalid username format" do
    visit signup_path
    
    fill_in "Username", with: "invalid username!"
    fill_in "Email", with: "test@example.com"
    fill_in "Password", with: "password123"
    fill_in "Password confirmation", with: "password123"
    
    click_button "Sign Up"
    
    expect(page).to have_content("Username only allows letters, numbers and underscores")
  end
  
  scenario "User fails to sign up with too short password" do
    visit signup_path
    
    fill_in "Username", with: "testuser"
    fill_in "Email", with: "test@example.com"
    fill_in "Password", with: "short"
    fill_in "Password confirmation", with: "short"
    
    click_button "Sign Up"
    
    expect(page).to have_content("Password is too short")
  end
end
