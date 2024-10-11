module SessionsHelper
  # 渡されたユーザーでログインする
  def log_in(user)
    session[:user_id] = user.id
    session[:session_token] = user.session_token
  end

  # 記憶トークンcookieに対応するユーザーを返す
  def current_user
    if (user_id = session[:user_id]) # 代入だよ
      user = User.find_by(id: user_id)
      @current_user = user if user && session[:session_token] == user.session_token
    elsif (user_id = cookies.encrypted[:user_id])
      user = User.find_by(id: user_id)
      if user && user.authenticated?(cookies[:remember_token]) # cookieの場合のみ
        log_in user
        @current_user = user
      end
    end
  end

  def current_user?(user)
    user && user == current_user
  end

  # ユーザーがログインしていればtrue、その他ならfalseを返す
  def logged_in?
    !current_user.nil?
  end

  # 永続セッションを破棄
  def forget(user)
    user.forget
    cookies.delete(:user_id) # ハッシュじゃなくてメソッド
    cookies.delete(:remember_token)
  end

  # 現在のユーザーをログアウトする
  def log_out
    forget(current_user)
    reset_session
    @current_user = nil
  end

  # 永続化セッションのためにuserをdbに記憶する
  def remember(user)
    user.remember
    cookies.permanent.encrypted[:user_id] = user.id # 期限を20年にしたりしてる .encryptedで暗号化も(ハッシュ化じゃないよ)
    cookies.permanent[:remember_token] = user.remember_token
  end

  # アクセスしようとしたurlを保存
  def store_location
    session[:forwarding_url] = request.original_url if request.get?
  end
end
