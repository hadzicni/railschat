class Users::SessionsController < Devise::SessionsController
  # Override to add activity logging for sign-in and sign-out

  def create
    super do |resource|
      if resource.persisted?
        ActivityLog.log_activity(
          user: resource,
          action: "login",
          target: resource,
          details: I18n.t('users.logged_in'),
          request: request
        )
      end
    end
  end

  def destroy
    ActivityLog.log_activity(
      user: current_user,
      action: "logout",
      target: current_user,
      details: I18n.t('users.logged_out'),
      request: request
    )
    super
  end

  protected

  def after_sign_in_path_for(resource)
    stored_location_for(resource) || root_path
  end

  def after_sign_out_path_for(resource_or_scope)
    root_path
  end
end
