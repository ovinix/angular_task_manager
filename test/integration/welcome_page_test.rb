require 'test_helper'

class WelcomePageTest < ActionDispatch::IntegrationTest
  
  test "root layout without user" do
    visit root_path
    assert page.has_link?("Sign up now!", href: new_user_registration_path)
    assert page.assert_selector('a', new_user_registration_path)
    assert page.has_link?("Sign in", href: new_user_session_path)
    assert page.assert_selector('a', new_user_session_path)
    assert page.assert_selector('a', root_path)
  end
end
