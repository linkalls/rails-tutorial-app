# frozen_string_literal: true

class SessionsController < ApplicationController
  def new; end

  def create
    # p params[:session][:email]
    user = User.find_by(email: params[:session][:email].downcase)
    if user&.authenticate(params[:session][:password])
      reset_session
      log_in(user) # sessionにいれる
      redirect_to user

      # ユーザーログイン後にユーザー情報のページにリダイレクトする
    else
      flash.now[:danger] = 'Invalid email/password combination' # 本当は正しくない
      # render 'new', status: :unprocessable_entity
      render 'new', status: :unprocessable_entity # render "newやで"
    end
  end

  def destroy
    log_out
    redirect_to root_url, status: :see_other
  end
end
