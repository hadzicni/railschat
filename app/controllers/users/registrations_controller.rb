class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [ :create ]
  before_action :configure_account_update_params, only: [ :update ]

  protected

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [ :first_name, :last_name, :locale ])
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [ :first_name, :last_name, :locale, :bio, :location, :website ])
  end

  # Override create to set locale based on current session
  def create
    build_resource(sign_up_params)

    # Set locale from session or current I18n.locale
    resource.locale = session[:locale] || I18n.locale.to_s

    resource.save
    yield resource if block_given?
    if resource.persisted?
      # Log registration activity
      ActivityLog.log_activity(
        user: resource,
        action: 'register',
        target: resource,
        details: "Neuer Benutzer registriert: #{resource.email}",
        ip_address: request.remote_ip
      )
      
      if resource.active_for_authentication?
        set_flash_message! :notice, :signed_up
        sign_up(resource_name, resource)
        respond_with resource, location: after_sign_up_path_for(resource)
      else
        set_flash_message! :notice, :"signed_up_but_#{resource.inactive_message}"
        expire_data_after_sign_up!
        respond_with resource, location: new_session_path(resource_name)
      end
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end

  # Override update to log profile updates
  def update
    self.resource = resource_class.to_adapter.get!(send(:"current_#{resource_name}").to_key)
    prev_unconfirmed_email = resource.unconfirmed_email if resource.respond_to?(:unconfirmed_email)

    resource_updated = update_resource(resource, account_update_params)
    yield resource if block_given?
    if resource_updated
      # Log profile update activity
      ActivityLog.log_activity(
        user: resource,
        action: 'profile_update',
        target: resource,
        details: "Profil aktualisiert",
        ip_address: request.remote_ip
      )
      
      set_flash_message_for_update(resource, prev_unconfirmed_email)
      bypass_sign_in resource, scope: resource_name if sign_in_after_change_password?

      respond_with resource, location: after_update_path_for(resource)
    else
      clean_up_passwords resource
      set_minimum_password_length
      respond_with resource
    end
  end
end
