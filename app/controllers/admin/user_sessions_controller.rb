class Admin::UserSessionsController < Admin::BaseController
  layout 'admin/layouts/login'
  skip_before_action :require_admin_login, only: %i[new create]
  skip_before_action :require_admin_role, only: %i[new create]

  def new; end

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
    redirect_to root_path, success: 'ログアウトしました'
  end
end
