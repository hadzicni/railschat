class Admin::DashboardController < Admin::BaseController
  def index
    @total_users = User.count
    @admin_users = User.joins(:roles).where(roles: { name: "admin" }).count
    @banned_users = User.banned_users.count
    @active_users = User.active_users.count
    @total_rooms = Room.count
    @total_messages = Message.count
    @total_roles = Role.count
    @recent_users = User.order(created_at: :desc).limit(5)
    @recent_messages = Message.includes(:user, :room).order(created_at: :desc).limit(10)
    @active_rooms = Room.joins(:messages)
                       .group("rooms.id")
                       .order("COUNT(messages.id) DESC")
                       .limit(5)
    @role_distribution = Role.joins(:users).group("roles.name").count
  end
end
