require 'test_helper'

class MicropostTest < ActiveSupport::TestCase

  def setup
    @user = users(:michael)
    @reply_user = users(:archer)
    @micropost = @user.microposts.build(content: "Lorem ipsum")
  end

  test "should be valid" do
    assert @micropost.valid?
  end

  test "user id should be present" do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

  test "content should be present" do
    @micropost.content = "   "
    assert_not @micropost.valid?
  end

  test "content should be at most 140 characters" do
    @micropost.content = "a" * 141
    assert_not @micropost.valid?
  end

  test "reply message " do
    @micropost.content = "aaa @Sterling_Archer aaa" 
    @micropost.save
    assert_equal @micropost.in_reply_to, @reply_user.id.to_s
  end

  test "order should be most recent first" do
    assert_equal microposts(:most_recent), Micropost.first
  end
end
