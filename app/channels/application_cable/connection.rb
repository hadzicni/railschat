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
      # Simple approach: try to find user from request headers or session
      if user_id = request.session.dig("warden.user.user.key", 0, 0)
        User.find_by(id: user_id)
      else
        # For testing: allow anonymous connections
        # In production you'd want to reject_unauthorized_connection
        logger.warn "ActionCable: No authenticated user found, allowing anonymous connection"
        User.first # Temporary: use first user for testing
      end
    end
  end
end
