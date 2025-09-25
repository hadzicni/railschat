class Role < ApplicationRecord
  has_many :user_roles, dependent: :destroy
  has_many :users, through: :user_roles

  validates :name, presence: true, uniqueness: true
  validates :permissions, presence: true

  # Store permissions as JSON in Rails 8
  serialize :permissions, type: Array, coder: JSON
  before_save :ensure_permissions_is_array

  # Predefined system roles
  SYSTEM_ROLES = {
    "admin" => {
      description: "Full administrative access",
      color: "#dc3545",
      permissions: [ "manage_users", "manage_roles", "manage_rooms", "ban_users", "unban_users", "delete_messages", "moderate_chat", "view_admin_panel", "create_announcements", "manage_settings", "view_reports", "export_data" ]
    },
    "moderator" => {
      description: "Chat moderation capabilities",
      color: "#fd7e14",
      permissions: [ "ban_users", "unban_users", "delete_messages", "moderate_chat", "view_reports" ]
    },
    "vip" => {
      description: "VIP user with enhanced features",
      color: "#6f42c1",
      permissions: [ "create_rooms", "pin_messages" ]
    },
    "user" => {
      description: "Regular user",
      color: "#6c757d",
      permissions: [ "send_messages", "join_rooms" ]
    }
  }.freeze

  # All available permissions
  PERMISSIONS = [
    "manage_users",      # Create, edit, delete users
    "manage_roles",      # Create, edit, delete roles
    "manage_rooms",      # Create, edit, delete chat rooms
    "ban_users",         # Ban users from the platform
    "unban_users",       # Unban previously banned users
    "delete_messages",   # Delete any user's messages
    "moderate_chat",     # General chat moderation
    "view_admin_panel",  # Access admin dashboard
    "create_announcements", # Create system announcements
    "manage_settings",   # Change application settings
    "view_reports",      # View user reports and analytics
    "export_data",       # Export user data and analytics
    "create_rooms",      # Create new chat rooms
    "pin_messages",      # Pin important messages
    "send_messages",     # Send messages in chat
    "join_rooms"         # Join chat rooms
  ].freeze

  # Check if role has specific permission
  def has_permission?(permission)
    permissions.include?(permission.to_s)
  end

  # Get role color for UI display
  def color_class
    case color
    when "#dc3545" then "text-danger"
    when "#fd7e14" then "text-warning"
    when "#6f42c1" then "text-purple"
    else "text-secondary"
    end
  end

  # Class method to create all system roles
  def self.create_system_roles!
    SYSTEM_ROLES.each do |role_name, role_data|
      role = find_or_create_by(name: role_name) do |r|
        r.description = role_data[:description]
        r.color = role_data[:color]
        r.permissions = role_data[:permissions]
      end

      # Update existing roles if permissions have changed
      if role.persisted? && role.permissions != role_data[:permissions]
        role.update!(
          description: role_data[:description],
          color: role_data[:color],
          permissions: role_data[:permissions]
        )
      end

      puts "Role '#{role_name}' created/updated with #{role.permissions&.length || 0} permissions"
    end
  end

  private

  def ensure_permissions_is_array
    self.permissions = [] if permissions.nil?
    self.permissions = JSON.parse(permissions) if permissions.is_a?(String)
  end
end
