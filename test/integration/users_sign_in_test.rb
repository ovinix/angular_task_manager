require 'test_helper'

class UsersSignInTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:first)
  end

  test "sign in layout" do
    visit new_user_session_path
    assert page.has_css?("form#new_user")
    assert page.has_field?("Email", type: "email")
    assert page.has_field?("Password", type: "password")
    assert page.has_button?("Log in")
    assert page.has_link?("Forgot your password?", href: new_user_password_path)
    assert page.assert_selector('a', new_user_password_path)
    assert page.assert_selector('a', new_user_registration_path)
    assert page.assert_selector('a', user_omniauth_authorize_path(:facebook))
    assert page.assert_selector('a', root_path)
  end

  test "should sign in a user" do
    visit new_user_session_path
    fill_in "Email", with: @user.email.to_s
    fill_in "Password", with: "password"
    click_button "Log in"
    assert_match @user.lists.first.title.to_s, page.body
    assert page.has_content?(@user.lists.first.title.to_s)
    assert current_path == root_path
  end

  test "shouldn't sign in a user with wrong email/password" do
    visit new_user_session_path
    fill_in "Email", with: @user.email.to_s
    fill_in "Password", with: "wrongpassword"
    click_button "Log in"
    assert page.has_content?("Invalid email or password.")

    fill_in "Email", with: "wrongemail"
    fill_in "Password", with: "password"
    click_button "Log in"
    assert page.has_content?("Invalid email or password.")
  end
end
