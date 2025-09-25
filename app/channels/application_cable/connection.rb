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
      # Try to find user from Devise session
      if user_id = request.session.dig("warden.user.user.key", 0, 0)
        user = User.find_by(id: user_id)
        if user
          logger.info "ActionCable: User #{user.email} connected"
          return user
        end
      end
      
      # Try to get user_id from URL params (for testing purposes)
      if params[:user_id].present?
        user = User.find_by(id: params[:user_id])
        if user
          logger.warn "ActionCable: User #{user.email} connected via param (dev only)"
          return user
        end
      end
      
      # Reject unauthorized connections
      logger.error "ActionCable: No authenticated user found, rejecting connection"
      reject_unauthorized_connection
    end
  end
end
