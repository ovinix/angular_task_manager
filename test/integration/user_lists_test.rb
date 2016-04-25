require 'test_helper'

class UserListsTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:first)
    @list = @user.lists.first
    Capybara.current_driver = Capybara.javascript_driver
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start 
    log_in_as @user
    visit root_path
  end

  def teardown
    click_link("Sign out", href: destroy_user_session_path)
    DatabaseCleaner.clean
    Capybara.use_default_driver
  end

  test "lists layout" do
    assert page.has_field?("new_list")
    assert page.has_button?("Add TODO List")
    @user.lists.each do |list|
      assert page.has_content?(list.title)
      assert assert_selector("#list-#{list.id} .panel-heading span[title='Edit']")
      assert assert_selector("#list-#{list.id} .panel-heading span[title='Delete']")
    end    
  end

  test "should delete a list" do
    assert_difference "@user.lists.count", -1 do
      find("#list-#{@list.id} .panel-heading span[title='Delete']").click
      sleep 0.1 # need to wait for Ajax
    end
    assert_not page.has_content?(@list.title.to_s)
  end

  test "should update a list title" do
    find("#list-#{@list.id} .panel-heading span[title='Edit']").click
    fill_in "list_title", with: "New title"
    click_button("Save")
    assert page.has_content?("New title")
  end

  test "shouldn't update a list title" do
    find("#list-#{@list.id} .panel-heading span[title='Edit']").click
    fill_in "list_title", with: "New title"
    click_button("Cancel")
    assert_not page.has_content?("New title")
  end

  test "shouldn't update a list with blank title" do
    find("#list-#{@list.id} .panel-heading span[title='Edit']").click
    fill_in "list_title", with: "    "
    click_button("Save")
    assert page.has_content?(@list.title)
  end

  test "should create a list" do
    assert_difference "@user.lists.count", 1 do
      fill_in "new_list", with: "New title"
      click_button("Add TODO List")
      sleep 0.1 # need to wait for Ajax
    end
    assert page.has_content?("New title")
  end

  test "shouldn't create a list with blank title" do
    assert_no_difference "@user.lists.count" do
      fill_in "new_list", with: "     "
      click_button("Add TODO List")
    end
  end
end
