class Admin::UserSessionsController < ApplicationController
  layout 'admin/layouts/login'

  def create
    @user = login(params[:email], params[:password])

    if @user
      redirect_back_or_to admin_root_path, success: 'ログインしました'
    else
      flash.now[:danger] = 'ログインに失敗しました'
      render :new
    end
  end

  def destroy
    logout
    redirect_to root_path, notice: 'ログアウトしました'
  end
end
