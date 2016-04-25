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
    visit "#/list/#{@task.list_id}/task/#{@task.id}"
  end

  def teardown
    click_link("Sign out", href: destroy_user_session_path)
    DatabaseCleaner.clean
    Capybara.use_default_driver
  end

  test "comments layout" do
    assert page.has_button?("Add Comment") 
    @task.comments.each do |comment|
      assert page.has_content?(comment.user.name)
      assert page.has_content?(comment.content)
      assert page.assert_selector("#comment-#{comment.id} span[title='Delete']")
    end  
  end

  test "should delete a comment" do
    assert_difference "@user.comments.count", -1 do
      find("#comment-#{@comment.id} span[title='Delete']").click
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
  end
end
