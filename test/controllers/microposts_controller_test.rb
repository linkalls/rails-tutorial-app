require 'test_helper'

class MicropostsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @micropost = microposts(:orange)
  end

  test 'ログインしてなかったらredirect' do
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: {
        micropost: {
          content: 'Loremだよ'
        }
      }
    end
    assert_redirected_to login_url
  end

  test 'destroyの時にログインしてなかったらリダイレクト' do
    assert_no_difference 'Micropost.count' do
      delete micropost_path(@micropost)
    end
    assert_response :see_other
    assert_redirected_to login_url
  end

  test '間違ったmicropostを削除するとredirect' do
    log_in_as(users(:michael))
    micropost = microposts(:ants)
    assert_no_difference 'Micropost.count' do
      delete micropost_path(micropost)
    end
    assert_response :see_other
    assert_redirected_to root_url
  end
end
