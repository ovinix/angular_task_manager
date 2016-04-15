require 'test_helper'

class ListTest < ActiveSupport::TestCase
  
  def setup
    @user = users(:first)
    @list = @user.lists.build(title: "Title")
  end

  test "should be valid" do
    assert @list.valid?    
  end

  test "user id should be present" do
    @list.user_id = nil
    assert_not @list.valid?
  end

  test "title should be present" do
    @list.title = nil
    assert_not @list.valid?    
  end

  test "title should be at most 50 characters" do
    @list.title = "a" * 51
    assert_not @list.valid?
  end

  test "order should be most recent first" do
    assert_equal lists(:most_recent), @user.lists.first
  end
end
