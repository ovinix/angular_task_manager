require 'test_helper'

class UsersResetPasswordTest < ActionDispatch::IntegrationTest
  
  test "reset layout" do
    visit new_user_password_path
    assert page.has_css?("form#new_user")
    assert page.has_field?("Email", type: "email")
    assert page.has_button?("Send me reset password instructions")
  end

  test "should sent reset instractions" do
    visit new_user_password_path
    fill_in "Email", with: users(:first).email.to_s
    click_button "Send me reset password instructions"
    assert page.has_content?("You will receive an email with instructions on how to reset your password in a few minutes.")
    assert current_path == new_user_session_path
  end

  test "shouldn't reset with wrong email" do
    visit new_user_password_path
    fill_in "Email", with: "example@email.com"
    click_button "Send me reset password instructions"
    assert page.has_content?("Email not found")
    assert page.has_css?('.field_with_errors #user_email')
  end
end
