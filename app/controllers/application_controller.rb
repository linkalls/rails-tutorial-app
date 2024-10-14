class ApplicationController < ActionController::Base
  include SessionsHelper # どのコントローラからでもログイン関連のメソッドを呼び出せるように

  # def hello
  #   render html: 'hello, world!'
  # end

  private

  # ログイン済みユーザーかどうか確認
  def logged_in_user
    return if logged_in?

    store_location
    flash[:danger] = 'Please log in.'
    redirect_to login_url, status: :see_other
  end
end
