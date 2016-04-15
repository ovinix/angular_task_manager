require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  
  def setup
    @user = users(:first)
    @task = tasks(:one)
    @comment = @task.comments.build(content: "Comment content", user_id: @user.id)
  end

  test "should be valid" do
    assert @comment.valid?    
  end

  test "user id should be present" do
    @comment.user_id = nil
    assert_not @comment.valid?
  end

  test "task id should be present" do
    @comment.task_id = nil
    assert_not @comment.valid?
  end

  test "content should be present" do
    @comment.content = nil
    assert_not @comment.valid?    
  end

  test "content should be at most 140 characters" do
    @comment.content = "a" * 141
    assert_not @comment.valid?
  end

  test "order should be most recent last" do
    assert_equal @comment, @task.comments.last
  end
end
