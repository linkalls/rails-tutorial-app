class PasswordResetsController < ApplicationController
  before_action :get_user, only: %i[edit update]
  before_action :valid_user, only: %i[edit update]
  before_action :check_expiration, only: %i[edit update]

  def new; end

  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user

      @user.create_reset_digest
      @user.send_password_reset_email
      flash[:info] = 'email sent with password reset instructions'
      redirect_to root_url
    else
      flash.now[:danger] = 'email adress not found'
      render 'new', status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if params[:user][:password].empty?
      # debugger
      @user.errors.add(:password, :blank)
      render 'edit', status: :unprocessable_entity
    elsif @user.update(user_params)
      # ユーザーの全セッションを無効化
      @user.update_attribute(:remember_digest, nil)
      reset_session
      log_in @user
      flash[:success] = 'Password has been reset.'
      redirect_to @user
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  private

  # strong parameter
  def user_params
    params.require(:user).permit(:password, :password_confirmation) # この属性のみをformから取得する
  end

  def check_expiration
    return unless @user.password_reset_expired?

    flash[:danger] = 'パスワードリセット期限を過ぎています'
    redirect_to new_password_reset_url
  end

  def get_user
    @user = User.find_by(email: params[:email])
    # debugger
  end

  # 正しいユーザーかどうか確認する
  def valid_user
    # debugger
    return if @user&.activated? && @user&.authenticated?(:reset, params[:id])

    redirect_to root_url
  end
end
