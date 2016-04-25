require 'test_helper'

class TaskTest < ActiveSupport::TestCase
  
  def setup
    @user = users(:first)
    @list = lists(:one)
    @task = @list.tasks.build(content: "Task content", user_id: @user.id)
  end

  test "should be valid" do
    assert @task.valid?    
  end

  test "user id should be present" do
    @task.user_id = nil
    assert_not @task.valid?
  end

  test "list id should be present" do
    @task.list_id = nil
    assert_not @task.valid?
  end

  test "content should be present" do
    @task.content = nil
    assert_not @task.valid?    
  end

  test "content should be at most 140 characters" do
    @task.content = "a" * 141
    assert_not @task.valid?
  end
end
