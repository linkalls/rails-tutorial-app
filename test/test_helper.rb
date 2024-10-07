ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require 'minitest/reporters'
Minitest::Reporters.use!

class ActiveSupport::TestCase
  # 指定のワーカー数でテストを並列実行する
  parallelize(workers: :number_of_processors)

  # test/fixtures/*.ymlにあるすべてのfixtureをセットアップする
  fixtures :all
  include ApplicationHelper # * AplicationHelperで定義したものを使えるように
  # テストユーザーがログイン中の場合にtrueを返す
  def is_logged_in?
    !session[:user_id].nil?
  end

  # test userとしてログイン
  def log_in_as(user)
    session[:user_id] = user.id
  end
end

# こっから下は統合テスト用
class ActionDispatch::IntegrationTest
  # test userとしてログイン
  def log_in_as(user, password: 'password', remember_me: '1')
    post login_path, params: {
      session: {
        email: user.email,
        password:, # 省略記法
        remember_me:
      }
    }
  end
end
