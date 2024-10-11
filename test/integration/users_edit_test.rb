require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:michael)
    @other_user = users(:archer)
  end

  test 'user friendly forwarding' do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_path(@user)
    name = 'Foo Bar'
    email = 'foo@bar.com'
    patch user_path(@user), params: { user: { name:,
                                              email:,
                                              password: '',
                                              password_confirmation: '' } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end

  test 'user friendly forwardingで初回のみ転送を確認' do
    get edit_user_path(@user)
    assert_equal session[:forwarding_url], edit_user_url(@user)
    log_in_as(@user)
    assert_nil session[:forwarding_url]
    name = 'Foo Bar'
    email = 'foo@bar.com'
    patch user_path(@user), params: {
      user: {
        name:,
        email:,
        password: '',
        password_confirmation: ''
      }
    }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name, @user.name
    assert_equal email, @user.email
  end

  test 'indexはログインしないと見れない' do
    get users_path
    assert_redirected_to login_path
  end

  test '間違ったユーザーがeditするときはredirectすべき' do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end

  test '間違ったユーザーがupdateするときはredirectするべきである' do
    log_in_as(@other_user)
    patch user_path(@user), params: {
      user: {
        name: @user.name,
        email: @user.email,
        password: '',
        password_confirmation: ''
      }
    }

    assert flash.empty?
    assert_redirected_to root_url
  end

  test 'editにログインなしでアクセスされたときはredirectするべき' do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_path
  end

  test 'updateにログインなしでアクセスされたときはredirectするべき' do
    patch user_path(@user), params: {
      user: {
        name: @user.name,
        email: @user.email
      }
    }
    assert_not flash.empty?
    assert_redirected_to login_url
  end

  test 'edit error' do
    log_in_as(@user) # ログインしないとかえられないから
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: {
      user: {
        name: '',
        email: 'foo@invalid',
        password: 'foo',
        password_confirmation: 'bar'
      }
    }
    assert_response :unprocessable_entity
    assert_template 'users/edit'
    assert_select 'div.alert', text: 'The form contains 4 errors.'
  end

  test 'edit成功' do
    log_in_as(@user) # ログインしないとかえられないから
    get edit_user_path(@user)
    assert_template 'users/edit'
    name = 'Foo Bar'
    email = 'foo@bar.com'
    patch user_path(@user), params: {
      user: {
        name: name, # rubocop:disable Style/HashSyntax
        email: email, # rubocop:disable Style/HashSyntax
        password: '',
        password_confirmation: ''
      }
    }
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_not flash.empty?
    @user.reload # dbからの情報を更新しなきゃ
    assert_equal name, @user.name
    assert_equal email, @user.email
  end
end
