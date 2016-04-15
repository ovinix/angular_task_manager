require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:first)
    visit new_user_session_path
    fill_in "Email", with: @user.email.to_s
    fill_in "Password", with: "password"
    click_button "Log in"
  end
  
  test "edit user layout" do
    visit edit_user_registration_path
    assert page.has_css?("form#edit_user")
    assert page.has_field?("Email", type: "email")
    assert page.has_field?("Name", type: "text")
    assert page.has_field?("Password", type: "password")
    assert page.has_field?("Password confirmation", type: "password")
    assert page.has_field?("Current password", type: "password")
    assert page.has_button?("Update")
    assert page.has_button?("Cancel my account")
  end

  test "should update a user" do
    visit edit_user_registration_path
    fill_in "Email", with: "example@email.com"
    fill_in "Name", with: "Example"
    fill_in "Password", with: "newpassword"
    fill_in "Password confirmation", with: "newpassword"
    fill_in "Current password", with: "password"
    click_button "Update"
    assert current_path == root_path
    assert page.has_content?("Your account has been updated successfully.")
  end

  test "shouldn't update a user without current password" do
    visit edit_user_registration_path
    click_button "Update"
    assert page.has_content?("Current password can't be blank")
    assert page.has_css?('.field_with_errors #user_current_password')
  end

  test "shouldn't update a user with wrong password confirmation" do
    visit edit_user_registration_path
    fill_in "Password", with: "newpassword"
    fill_in "Password confirmation", with: "newpassZord"
    fill_in "Current password", with: "password"
    click_button "Update"
    assert page.has_content?("Password confirmation doesn't match Password")
    assert page.has_css?('.field_with_errors #user_password_confirmation')
  end

  test "should remove a user" do
    visit edit_user_registration_path
    click_button "Cancel my account"
    assert page.has_content?("Bye! Your account has been successfully cancelled. We hope to see you again soon.")
    assert current_path = root_path
    visit new_user_password_path
    fill_in "Email", with: @user.email.to_s
    click_button "Send me reset password instructions"
    assert page.has_content?("Email not found")
    assert page.has_css?('.field_with_errors #user_email')
  end
end
