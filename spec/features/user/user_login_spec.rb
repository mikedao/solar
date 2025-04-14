require 'rails_helper'

RSpec.feature "User Login", type: :feature do
  let!(:user) { create(:user, username: "testuser", email: "test@example.com", password: "password123") }
  
  scenario "User successfully logs in with valid credentials" do
    visit login_path
    
    fill_in "Email", with: user.email
    fill_in "Password", with: "password123"
    
    click_button "Log In"
    
    expect(page).to have_content("Logged in successfully!")
    expect(page).to have_content("Welcome, testuser")
    expect(current_path).to eq(root_path)
  end
  
  scenario "User fails to log in with invalid email" do
    visit login_path
    
    fill_in "Email", with: "wrong@example.com"
    fill_in "Password", with: "password123"
    
    click_button "Log In"
    
    expect(page).to have_content("Invalid email or password")
    expect(current_path).to eq(login_path)
  end
  
  scenario "User fails to log in with invalid password" do
    visit login_path
    
    fill_in "Email", with: user.email
    fill_in "Password", with: "wrongpassword"
    
    click_button "Log In"
    
    expect(page).to have_content("Invalid email or password")
    expect(current_path).to eq(login_path)
  end
  
  scenario "User fails to log in with empty credentials" do
    visit login_path
    
    click_button "Log In"
    
    expect(page).to have_content("Invalid email or password")
    expect(current_path).to eq(login_path)
  end

  scenario "User fails to sign up with too short password" do
    visit signup_path
    
    fill_in "Username", with: "testuser"
    fill_in "Email", with: "test@example.com"
    fill_in "Password", with: "short"
    fill_in "Password confirmation", with: "short"
    
    click_button "Sign Up"
    
    expect(page).to have_content("Password is too short (minimum is 8 characters)")
  end
end
