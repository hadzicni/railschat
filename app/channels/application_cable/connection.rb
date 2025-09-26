module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      # Get authenticated user from the session with proper error handling
      self.current_user = find_verified_user
    rescue => e
      reject_unauthorized_connection
    end

    private

    def find_verified_user
      # Try multiple methods to find authenticated user

      # Method 1: Try Devise session (most reliable)
      if user_id = request.session.dig("warden.user.user.key", 0, 0)
        user = User.find_by(id: user_id)
        if user && !user.banned?
          return user
        end
      end

      # Method 2: Try cookies (backup for session issues)
      if request.cookies["_railschat_session"].present?
        begin
          # Try to decrypt the session cookie to get user info
          decoded_session = Rails.application.message_verifier(:signed_cookie).verify(request.cookies["_railschat_session"])
          if decoded_session && decoded_session.dig("warden.user.user.key", 0, 0)
            user_id = decoded_session.dig("warden.user.user.key", 0, 0)
            user = User.find_by(id: user_id)
            if user && !user.banned?
              return user
            end
          end
        rescue => e
        end
      end

      # Method 2.5: Try session store directly (for fresh logins)
      if request.session["warden.user.user.session"].present?
        begin
          user_id = request.session["warden.user.user.session"]["id"]
          if user_id
            user = User.find_by(id: user_id)
            if user && !user.banned?
              return user
            end
          end
        rescue => e
        end
      end

      # Method 3: Development mode - allow with user_id param
      if Rails.env.development? && params[:user_id].present?
        user = User.find_by(id: params[:user_id])
        if user
          return user
        end
      end

      # Method 4: Development mode fallback - use first user
      if Rails.env.development?
        user = User.first
        if user
          return user
        end
      end

      reject_unauthorized_connection
    end
  end
end
