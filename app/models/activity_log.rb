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
    when "login" then I18n.t('activity_log.actions.login')
    when "logout" then I18n.t('activity_log.actions.logout')
    when "register" then I18n.t('activity_log.actions.register')
    when "profile_update" then I18n.t('activity_log.actions.profile_update')
    when "create_room" then I18n.t('activity_log.actions.create_room', room_name: target&.name)
    when "join_room" then I18n.t('activity_log.actions.join_room', room_name: target&.name)
    when "leave_room" then I18n.t('activity_log.actions.leave_room', room_name: target&.name)
    when "message_send" then I18n.t('activity_log.actions.message_send', room_name: target&.room&.name)
    when "ban_user" then I18n.t('activity_log.actions.ban_user', user_name: target&.display_name)
    when "unban_user" then I18n.t('activity_log.actions.unban_user', user_name: target&.display_name)
    when "assign_role" then I18n.t('activity_log.actions.assign_role')
    when "remove_role" then I18n.t('activity_log.actions.remove_role')
    when "delete_message" then I18n.t('activity_log.actions.delete_message')
    else action.humanize
    end
  end
end
