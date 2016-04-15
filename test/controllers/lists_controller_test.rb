require 'test_helper'

class ListsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @user = users(:first)
    # sign_in @user
    @list = lists(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_select "a[href=?]", root_path
    assert_select "a[href=?]", new_user_registration_path
    assert_select "a[href=?]", new_user_session_path
    
    sign_in @user

    get :index
    assert_response :success
    assert_select "a[href=?]", root_path
    assert_select "a[href=?]", destroy_user_session_path
    assert_select "a[href=?]", edit_user_registration_path
    assert_not_nil assigns(:lists)
  end

  test "should get new" do
    get :new
    assert_redirected_to new_user_session_path

    sign_in @user

    get :new
    assert_redirected_to root_path

    post :new, format: :js
    assert_match CGI::escapeHTML('Add TODO List'), response.body
  end

  test "should create list" do
    assert_no_difference('@user.lists.count') do
      post :create, list: { title: @list.title, user_id: @list.user_id }
    end

    sign_in @user

    assert_difference('@user.lists.count') do
      post :create, list: { title: @list.title, user_id: @list.user_id }
    end

    assert_redirected_to root_path
  end

  test "should show list" do
    get :show, id: @list
    assert_redirected_to new_user_session_path

    sign_in @user

    get :show, id: @list
    assert_redirected_to root_path
  end

  test "should get edit" do
    get :edit, id: @list
    assert_redirected_to new_user_session_path

    sign_in @user

    get :edit, id: @list
    assert_redirected_to root_path

    post :edit, format: :js, id: @list
    assert_match CGI::escapeHTML('Edit List Title'), response.body
    assert_match @list.title.to_s, response.body
  end

  test "should update list" do
    patch :update, id: @list, list: { title: @list.title, user_id: @list.user_id }
    assert_redirected_to new_user_session_path

    sign_in @user

    patch :update, id: @list, list: { title: @list.title, user_id: @list.user_id }
    assert_redirected_to root_path
  end

  test "should destroy list" do
    assert_no_difference('@user.lists.count') do
      delete :destroy, id: @list
    end

    sign_in @user

    assert_difference('@user.lists.count', -1) do
      delete :destroy, id: @list
    end

    assert_redirected_to root_path
  end
end
