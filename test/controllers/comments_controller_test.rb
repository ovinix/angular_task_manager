require 'test_helper'

class CommentsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  def setup
    @user = users(:first)
    @task = tasks(:one)
    @comment = comments(:one)
  end

  test "should get create" do
    assert_no_difference('@user.comments.count') do
      post :create, task_id: @task.id, comment: { content: @comment.content }, format: :js
    end
    assert_response :unauthorized

    assert_no_difference('@user.comments.count') do
      post :create, task_id: @task.id, comment: { content: @comment.content }
    end
    assert_redirected_to new_user_session_path

    sign_in @user

    assert_difference '@user.comments.count', 1 do
      post :create, task_id: @task.id, comment: { content: @comment.content }, format: :js
    end

    assert_match @comment.content.to_s, response.body
  end

  test "should get destroy" do
    assert_no_difference('@user.comments.count') do
      delete :destroy, task_id: @task.id, id: @comment.id, format: :js
    end
    assert_response :unauthorized

    assert_no_difference('@user.comments.count') do
      delete :destroy, task_id: @task.id, id: @comment.id
    end
    assert_redirected_to new_user_session_path

    sign_in @user

    assert_difference '@user.comments.count', -1 do
      delete :destroy, task_id: @task.id, id: @comment.id, format: :js
    end
  end
end
