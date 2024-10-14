require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
  def setup
    @user = users(:michael)

    # このコードは慣習的にはよくない
    # @micropost = Micropost.new(content: 'Lorem ipsum', user_id: @user.id)
    @micropost = @user.microposts.build(content: 'Lorem ipsum') # userを経由するから慣習的に正しい
    # buildメソッドはオブジェクトを返すけどdbには反映されない
  end

  test 'should be valid' do
    assert @micropost.valid?
  end

  test 'content should be present' do
    @micropost.content = ' '
    assert_not @micropost.valid?
  end

  test 'contentは140文字以内である必要がある' do
    @micropost.content = 'a' * 141
    assert_not @micropost.valid?
    @micropost.content = 'a' * 140
    assert @micropost.valid?
  end

  test 'user id should be present' do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

  test '新しい順に並べる' do
    assert_equal microposts(:most_recent), Micropost.first
  end
end
