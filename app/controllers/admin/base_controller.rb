class Admin::BaseController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_admin!

  private

  def ensure_admin!
    unless current_user.admin? || current_user.can?("view_admin_panel")
      redirect_to root_path, alert: t('access.admin_required')
    end
  end
end
