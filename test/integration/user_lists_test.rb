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
    assert page.has_link?("Add TODO List", href: new_list_path)
    @user.lists.each do |list|
      assert page.assert_selector('a', edit_list_path(list))
      assert page.assert_selector("a[data-method='delete']", list_path(list))
    end    
  end

  test "should delete a list" do
    assert_difference "@user.lists.count", -1 do
      # find("a[href='#{list_path(@list)}'][data-method='delete']").click
      # page.driver.accept_modal :confirm
      accept_confirm do
        find("a[href='#{list_path(@list)}'][data-method='delete']").click
      end
      sleep 0.1 # need to wait for Ajax
    end
    assert_not page.has_content?(@list.title.to_s)
  end

  test "shouldn't delete a list" do
    assert_no_difference "@user.lists.count" do
      # find("a[href='#{list_path(@list)}'][data-method='delete']").click
      # page.driver.dismiss_modal :confirm
      dismiss_confirm do
        find("a[href='#{list_path(@list)}'][data-method='delete']").click
      end
    end
    assert page.has_content?(@list.title.to_s)
  end

  test "should update a list title" do
    find("a[href='#{edit_list_path(@list)}']").click
    fill_in "list_title", with: "New title"
    click_button("Save")
    assert page.has_content?("New title")
  end

  test "shouldn't update a list title" do
    find("a[href='#{edit_list_path(@list)}']").click
    fill_in "list_title", with: "New title"
    click_button("Close", match: :first)
    assert_not page.has_content?("New title")
  end

  test "shouldn't update a list with blank title" do
    find("a[href='#{edit_list_path(@list)}']").click
    fill_in "list_title", with: "    "
    click_button("Save")
    assert page.has_css?('.field_with_errors #list_title')
    click_button("Close", match: :first)
  end

  test "should create a list" do
    assert_difference "@user.lists.count", 1 do
      find("a[href='#{new_list_path}']").click
      fill_in "list_title", with: "New title"
      click_button("Save")
      sleep 0.1 # need to wait for Ajax
    end
    assert page.has_content?("New title")
  end

  test "shouldn't create a list" do
    assert_no_difference "@user.lists.count" do
      find("a[href='#{new_list_path}']").click
      fill_in "list_title", with: "New title"
      click_button("Close", match: :first)
    end
    assert_not page.has_content?("New title")
  end

  test "shouldn't create a list with blank title" do
    assert_no_difference "@user.lists.count" do
      find("a[href='#{new_list_path}']").click
      fill_in "list_title", with: "     "
      click_button("Save")
    end
    assert page.has_css?('.field_with_errors #list_title')
    click_button("Close", match: :first)
  end
end
