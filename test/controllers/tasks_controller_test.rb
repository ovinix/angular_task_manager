require 'test_helper'

class TasksControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @user = users(:first)
    @other_user = users(:second)
    @list = lists(:one)
    @task = tasks(:completed)
  end

  test "should get show" do
    get :show, id: @task.id, list_id: @list.id
    assert_redirected_to new_user_session_path

    post :show, id: @task.id, list_id: @list.id, format: :js
    assert_response :unauthorized

    sign_in @user

    get :show, id: @task.id, list_id: @list.id
    assert_redirected_to root_path

    post :show, id: @task.id, list_id: @list.id, format: :js
    assert_match @task.content, response.body
  end

  test "should create task" do
    assert_no_difference('@user.tasks.count') do
      post :create, list_id: @list.id, task: { content: @task.content }, format: :js
    end
    assert_response :unauthorized

    assert_no_difference('@user.tasks.count') do
      post :create, list_id: @list.id, task: { content: @task.content }
    end
    assert_redirected_to new_user_session_path

    sign_in @user

    assert_difference '@user.tasks.count', 1 do
      post :create, list_id: @list.id, task: { content: @task.content }, format: :js
    end

    assert_match @task.content.to_s, response.body
  end

  test "should update task" do
    patch :update, id: @task.id, list_id: @list.id, task: { content: @task.content }, format: :js
    assert_response :unauthorized

    patch :update, id: @task.id, list_id: @list.id, task: { content: @task.content }
    assert_redirected_to new_user_session_path

    sign_in @user

    patch :update, id: @task.id, list_id: @list.id, task: { content: "Updated" }, format: :js

    assert_match "Updated".to_s, response.body
  end

  test "should destroy task" do
    assert_no_difference('@user.tasks.count') do
      delete :destroy, id: @task.id, list_id: @list.id, format: :js
    end
    assert_response :unauthorized

    assert_no_difference('@user.tasks.count') do
      delete :destroy, id: @task.id, list_id: @list.id
    end
    assert_redirected_to new_user_session_path

    sign_in @user

    assert_difference '@user.tasks.count', -1 do
      delete :destroy, id: @task.id, list_id: @list.id, format: :js
    end
  end

  test "should complete task" do
    patch :complete, id: @task.id, list_id: @list.id, format: :js
    assert_response :unauthorized

    patch :complete, id: @task.id, list_id: @list.id
    assert_redirected_to new_user_session_path

    sign_in @user

    assert @task.completed?
    patch :complete, id: @task.id, list_id: @list.id, format: :js
    assert_not @task.reload.completed?

    patch :complete, id: @task.id, list_id: @list.id, format: :js
    assert @task.reload.completed?
  end

  test "should prioritize task" do
    patch :prioritize, id: @task.id, list_id: @list.id, format: :js
    assert_response :unauthorized

    patch :prioritize, id: @task.id, list_id: @list.id
    assert_redirected_to new_user_session_path

    sign_in @user

    assert @task.normal?
    patch :prioritize, id: @task.id, list_id: @list.id, format: :js
    assert @task.reload.important?

    patch :prioritize, id: @task.id, list_id: @list.id, format: :js
    assert @task.reload.normal?
  end

  test "shouldn't show task to another user" do
    sign_in @other_user

    get :show, id: @task.id, list_id: @list.id
    assert_no_match @task.content, response.body
    assert_redirected_to root_path

    post :show, id: @task.id, list_id: @list.id, format: :js
    assert_no_match @task.content, response.body
    assert_redirected_to root_path
  end

  test "shouldn't create task with another user" do
    sign_in @other_user
    assert_no_difference '@user.tasks.count' do
      post :create, list_id: @list.id, task: { content: @task.content }, format: :js
    end
    assert_redirected_to root_path
  end

  test "shouldn't update task with another user" do
    sign_in @other_user
    
    patch :update, id: @task.id, list_id: @list.id, task: { content: "Updated" }, format: :js
    assert_no_match "Updated".to_s, response.body
    assert_redirected_to root_path
  end

  test "shouldn't destroy task with another user" do
    sign_in @other_user
    
    assert_no_difference('@user.tasks.count') do
      delete :destroy, id: @task.id, list_id: @list.id
    end
    assert_redirected_to root_path
  end

  test "shouldn't complete task with another user" do
    sign_in @other_user
    
    assert @task.completed?
    patch :complete, id: @task.id, list_id: @list.id, format: :js
    assert @task.reload.completed?
    assert_redirected_to root_path
  end

  test "shouldn't prioritize task with another user" do
    sign_in @other_user
    
    assert @task.normal?
    patch :prioritize, id: @task.id, list_id: @list.id, format: :js
    assert_not @task.reload.important?
    assert_redirected_to root_path
  end
end
