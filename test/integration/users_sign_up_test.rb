require 'test_helper'

class UsersSignUpTest < ActionDispatch::IntegrationTest
  
  test "sign up layout" do
    visit new_user_registration_path
    assert page.has_css?("form#new_user")
    assert page.has_field?("Email", type: "email")
    assert page.has_field?("Name", type: "text")
    assert page.has_field?("Password", type: "password")
    assert page.has_field?("Password confirmation", type: "password")
    assert page.has_button?("Sign up")
  end

  test "should sign up a user" do
    visit new_user_registration_path
    fill_in "Email", with: "example@email.com"
    fill_in "Name", with: "Example"
    fill_in "Password", with: "password"
    fill_in "Password confirmation", with: "password"
    click_button "Sign up"
    assert current_path == root_path
    assert page.assert_selector('a', destroy_user_session_path)
  end

  test "shouldn't sign up with empty form" do
    visit new_user_registration_path
    click_button "Sign up"
    assert page.has_content?("Email can't be blank")
    assert page.has_css?('.field_with_errors #user_email') 
    assert page.has_content?("Password can't be blank")
    assert page.has_css?('.field_with_errors #user_password')
    assert page.has_content?("Name can't be blank")
    assert page.has_css?('.field_with_errors #user_name')
  end

  test "shouldn't sign up a user with wrong email" do
    visit new_user_registration_path
    fill_in "Email", with: "wrong@email"
    click_button "Sign up"
    assert page.has_content?("Email is invalid")
    assert page.has_css?('.field_with_errors #user_email') 
    assert page.has_content?("Password can't be blank")
    assert page.has_css?('.field_with_errors #user_password')
    assert page.has_content?("Name can't be blank")
    assert page.has_css?('.field_with_errors #user_name')
  end

  test "shouldn't sign up a user without password confirmation" do
    visit new_user_registration_path
    fill_in "Email", with: "example@email.com"
    fill_in "Name", with: "Name"
    fill_in "Password", with: "password"
    click_button "Sign up"
    assert page.has_content?("Password confirmation doesn't match Password")
    assert page.has_css?('.field_with_errors #user_password_confirmation')
  end

  test "shouldn't sign up a user with existing email" do
    visit new_user_registration_path
    fill_in "Email", with: users(:first).email.to_s
    fill_in "Name", with: "Name"
    fill_in "Password", with: "password"
    fill_in "Password confirmation", with: "password"
    click_button "Sign up"
    assert page.has_content?("Email has already been taken")
    assert page.has_css?('.field_with_errors #user_email')
  end

  test "shouldn't sign up a user with short password" do
    visit new_user_registration_path
    fill_in "Email", with: "example@email.com"
    fill_in "Name", with: "Name"
    fill_in "Password", with: "pass"
    fill_in "Password confirmation", with: "pass"
    click_button "Sign up"
    assert page.has_content?("Password is too short")
    assert page.has_css?('.field_with_errors #user_password')
  end

  test "shouldn't sign up a user with wrong password confirmation" do
    visit new_user_registration_path
    fill_in "Email", with: "example@email.com"
    fill_in "Name", with: "Name"
    fill_in "Password", with: "password"
    fill_in "Password confirmation", with: "passzord"
    click_button "Sign up"
    assert page.has_content?("Password confirmation doesn't match Password")
    assert page.has_css?('.field_with_errors #user_password_confirmation')
  end
end
