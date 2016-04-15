ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'
require 'minitest/reporters'
require 'capybara/rails'
require 'database_cleaner'
Minitest::Reporters.use!

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
  def log_in_as(user, opt ={})
    password = opt[:password] || 'password'
    visit new_user_session_path
    fill_in "Email", with: user.email.to_s
    fill_in "Password", with: password
    click_button "Log in"
  end
end

class ActionDispatch::IntegrationTest
  # Make the Capybara DSL available in all integration tests
  include Capybara::DSL

  # Reset sessions and driver between tests
  # Use super wherever this method is redefined in your individual test classes
  def teardown
    Capybara.reset_sessions!
    Capybara.use_default_driver
  end
end

# Added to solve
# 'SQLite3::BusyException: database is locked'
# error
class ActiveRecord::Base  
  mattr_accessor :shared_connection
  @@shared_connection = nil

  def self.connection
    @@shared_connection || retrieve_connection
  end
end  
ActiveRecord::Base.shared_connection = ActiveRecord::Base.connection
