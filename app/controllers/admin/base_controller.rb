class Admin::BaseController < ApplicationController
  protect_from_forgery
  layout 'admin/layouts/application'
  before_action :require_admin_login
  before_action :require_admin_role

  private

  def require_admin_login
    return if logged_in?

    redirect_to admin_login_path, danger: 'ログインしてください'
  end

  def require_admin_role
    return if current_user.admin?

    redirect_to root_path, danger: '権限がありません'
  end
end
