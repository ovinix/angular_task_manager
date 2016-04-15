require 'test_helper'

class UserCommentsTest < ActionDispatch::IntegrationTest
  
  def setup
    @user = users(:first)
    @list = lists(:one)
    @task = tasks(:one)
    @comment = comments(:one)
    Capybara.current_driver = Capybara.javascript_driver
    DatabaseCleaner.strategy = :transaction
    DatabaseCleaner.start 
    log_in_as @user
    visit root_path
    page.execute_script("$('.hoverable').show();") # Selenium couldn't interacte with invisible elements
    find("a[href='#{list_task_path(@list, @task)}'][data-toggle='modal']").click
  end

  def teardown
    click_button("Close", match: :first)
    click_link("Sign out", href: destroy_user_session_path)
    DatabaseCleaner.clean
    Capybara.use_default_driver
  end

  test "comments layout" do
    assert page.has_button?("Add Comment") 
    @task.comments.each do |comment|
      assert page.assert_selector("a[data-method='delete']", task_comment_path(comment.task, comment))
    end  
  end

  test "should delete a comment" do
    assert_difference "@user.comments.count", -1 do
      find("a[href='#{task_comment_path(@task, @comment)}'][data-method='delete']").click
      sleep 0.1 # need to wait for Ajax
    end
    assert_not page.has_content?(@comment.content.to_s)
  end

  test "should create a comment" do
    assert_difference "@user.comments.count", 1 do
      fill_in "comment_content", with: "New comment"
      click_button("Add Comment")
      sleep 0.1 # need to wait for Ajax
    end
    assert page.has_content?("New comment")
  end

  test "shouldn't create a comment" do
    assert_no_difference "@user.comments.count" do
      fill_in "comment_content", with: "     "
      click_button("Add Comment")
    end
    assert has_css?('.field_with_errors #comment_content')
  end
end
