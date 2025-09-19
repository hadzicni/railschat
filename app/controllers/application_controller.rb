class ApplicationController < ActionController::Base
  # Only allow modern browsers supporting webp images, web push, badges, import maps, CSS nesting, and CSS :has.
  allow_browser versions: :modern

  before_action :set_locale
  before_action :check_banned_user

  # Language switching method
  def set_language
    locale = params[:locale]
    if I18n.available_locales.map(&:to_s).include?(locale)
      session[:locale] = locale
      I18n.locale = locale

      # Save locale to user if logged in
      if user_signed_in?
        current_user.update_locale!(locale)
      end
    end
    redirect_back(fallback_location: root_path)
  end

  private

  def set_locale
    I18n.locale = extract_locale || I18n.default_locale
  end

  def extract_locale
    # Priority: URL param > User preference > Session > Browser language
    parsed_locale = params[:locale] ||
                   (user_signed_in? ? current_user.preferred_locale : nil) ||
                   session[:locale] ||
                   http_accept_language
    I18n.available_locales.map(&:to_s).include?(parsed_locale) ? parsed_locale : nil
  end

  def http_accept_language
    request.env["HTTP_ACCEPT_LANGUAGE"]&.scan(/^[a-z]{2}/)&.first
  end

  def check_banned_user
    if user_signed_in? && current_user.banned?
      sign_out current_user
      redirect_to new_user_session_path, alert: t("admin.banned_message", default: "Ihr Konto wurde gesperrt. Bitte wenden Sie sich an den Administrator.")
    end
  end
end
