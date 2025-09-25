class ActivityLog < ApplicationRecord
  belongs_to :user
  belongs_to :target, polymorphic: true, optional: true

  validates :action, presence: true

  scope :recent, -> { order(created_at: :desc) }
  scope :by_action, ->(action) { where(action: action) }
  scope :by_user, ->(user) { where(user: user) }

  # Common actions
  ACTIONS = {
    login: "login",
    logout: "logout",
    register: "register",
    profile_update: "profile_update",
    create_room: "create_room",
    join_room: "join_room",
    leave_room: "leave_room",
    message_send: "message_send",
    ban_user: "ban_user",
    unban_user: "unban_user",
    assign_role: "assign_role",
    remove_role: "remove_role",
    delete_message: "delete_message"
  }.freeze

  def self.log_activity(user:, action:, target: nil, details: nil, request: nil)
    create!(
      user: user,
      action: action,
      target: target,
      details: details,
      user_agent: request&.user_agent || "unknown"
    )
  end

  def action_description
    case action
    when "login" then "Hat sich angemeldet"
    when "logout" then "Hat sich abgemeldet"
    when "register" then "Hat sich registriert"
    when "profile_update" then "Hat Profil aktualisiert"
    when "create_room" then "Hat Raum '#{target&.name}' erstellt"
    when "join_room" then "Hat Raum '#{target&.name}' betreten"
    when "leave_room" then "Hat Raum '#{target&.name}' verlassen"
    when "message_send" then "Hat Nachricht gesendet in '#{target&.room&.name}'"
    when "ban_user" then "Hat Benutzer #{target&.display_name} gesperrt"
    when "unban_user" then "Hat Benutzer #{target&.display_name} entsperrt"
    when "assign_role" then "Hat Rolle zugewiesen"
    when "remove_role" then "Hat Rolle entfernt"
    when "delete_message" then "Hat Nachricht gelöscht"
    else action.humanize
    end
  end
end
