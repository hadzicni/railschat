class Admin::ActivityLogsController < Admin::BaseController
  def index
    @activity_logs = ActivityLog.includes(:user, :target)
                                .recent
                                .page(params[:page])
                                .per(25)

    # Filter by action if specified
    @activity_logs = @activity_logs.by_action(params[:action_filter]) if params[:action_filter].present?

    # Filter by user if specified
    @activity_logs = @activity_logs.by_user(params[:user_id]) if params[:user_id].present?

    @users = User.order(:email)
    @actions = ActivityLog::ACTIONS.values
  end
end
