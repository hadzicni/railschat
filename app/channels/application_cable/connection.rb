module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :current_user

    def connect
      # For now, just get any authenticated user from the session
      # This is a simplified approach for testing
      self.current_user = find_verified_user
    end

    private

    def find_verified_user
      # Try multiple methods to find authenticated user
      
      # Method 1: Try Devise session (most reliable)
      if user_id = request.session.dig("warden.user.user.key", 0, 0)
        user = User.find_by(id: user_id)
        if user
          logger.info "ActionCable: User #{user.email} connected via session"
          return user
        end
      end

      # Method 2: Try cookies (backup for session issues)
      if request.cookies['_railschat_session'].present?
        begin
          # Try to decrypt the session cookie to get user info
          decoded_session = Rails.application.message_verifier(:signed_cookie).verify(request.cookies['_railschat_session'])
          if decoded_session && decoded_session.dig("warden.user.user.key", 0, 0)
            user_id = decoded_session.dig("warden.user.user.key", 0, 0)
            user = User.find_by(id: user_id)
            if user
              logger.info "ActionCable: User #{user.email} connected via cookie"
              return user
            end
          end
        rescue => e
          logger.warn "ActionCable: Cookie verification failed: #{e.message}"
        end
      end

      # Method 3: Development mode - allow with user_id param
      if Rails.env.development? && params[:user_id].present?
        user = User.find_by(id: params[:user_id])
        if user
          logger.warn "ActionCable: User #{user.email} connected via param (dev only)"
          return user
        end
      end

      # Method 4: Development mode fallback - use first user
      if Rails.env.development?
        user = User.first
        if user
          logger.warn "ActionCable: Using first user #{user.email} as fallback (dev only)"
          return user
        end
      end

      # All methods failed
      logger.error "ActionCable: No authenticated user found, rejecting connection"
      reject_unauthorized_connection
    end
  end
end
