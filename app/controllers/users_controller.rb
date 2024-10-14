# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :logged_in_user, only: %i[edit update index destroy]
  before_action :correct_user, only: %i[edit update]
  before_action :admin_user, only: :destroy

  def show
    @user = User.find(params[:id])
    @microposts = @user.microposts.paginate(page: params[:page])
    redirect_to root_url and return unless @user.activated?
    # debugger # cmdで@userとか見れる
  end

  def new
    # debugger
    @user = User.new
  end

  def create
    # @user = User.new(params[:user])
    @user = User.new(user_params)
    if @user.save
      # UserMailer.account_activation(@user).deliver_now
      @user.send_activation_email
      flash[:info] = 'アカウント有効化をするためにメールを確認してください'
      redirect_to root_url
      # reset_session
      # log_in(@user)
      # flash[:success] = 'Welcome to the Sample App!'
      # redirect_to @user # railsが勝手にredirect_to user_url(@user)
    else
      render 'new', status: :unprocessable_entity
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params) # したのprivateのやつ
      flash[:success] = 'profileアップデート完了'
      redirect_to @user
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  def index
    # @users = User.paginate(page: params[:page])
    @users = User.where(activated: true).paginate(page: params[:page])
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = 'user削除'
    redirect_to users_url, status: :see_other
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation) # この属性のみをformから取得する
  end

  # # ログイン済みユーザーかどうか確認
  # def logged_in_user
  #   return if logged_in?
  #
  #   store_location
  #   flash[:danger] = 'Please log in.'
  #   redirect_to login_url, status: :see_other
  # end

  def correct_user
    @user = User.find(params[:id])
    redirect_to(root_url, status: :see_other) unless @user == current_user
  end

  # 管理者かどうか
  def admin_user
    redirect_to(root_path, status: :see_other) unless current_user.admin?
  end
end
