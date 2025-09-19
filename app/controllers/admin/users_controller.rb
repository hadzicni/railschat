class Admin::UsersController < Admin::BaseController
  before_action :set_user, only: [ :show, :edit, :update, :destroy, :toggle_admin, :ban_user, :unban_user ]

  def index
    @users = User.includes(:messages).order(:email)
    @total_users = @users.count
    @admin_users = @users.admins.count
    @regular_users = @users.regular_users.count
    @banned_users = @users.banned_users.count
  end

  def show
    @user_messages = @user.messages.includes(:room).order(created_at: :desc).limit(10)
    @user_rooms = Room.joins(:messages).where(messages: { user: @user }).distinct.limit(5)
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to admin_user_path(@user), notice: "Benutzer erfolgreich aktualisiert."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @user.can_be_deleted_by?(current_user)
      @user.destroy
      redirect_to admin_users_path, notice: "Benutzer erfolgreich gelöscht."
    else
      redirect_to admin_users_path, alert: "Benutzer konnte nicht gelöscht werden."
    end
  end

  def toggle_admin
    if @user == current_user
      redirect_to admin_users_path, alert: "Du kannst deine eigenen Admin-Rechte nicht ändern."
      return
    end

    if @user.admin?
      @user.remove_admin!
      message = "Administrator-Rechte entfernt."
    else
      @user.make_admin!
      message = "Administrator-Rechte gewährt."
    end

    redirect_to admin_users_path, notice: message
  end

  def ban_user
    if @user.can_be_banned_by?(current_user)
      reason = params[:reason] || "Verstoß gegen die Nutzungsrichtlinien"
      @user.ban!(reason)
      redirect_to admin_users_path, notice: "Benutzer #{@user.display_name} wurde gesperrt."
    else
      redirect_to admin_users_path, alert: "Benutzer konnte nicht gesperrt werden."
    end
  end

  def unban_user
    if @user.can_be_unbanned_by?(current_user)
      @user.unban!
      redirect_to admin_users_path, notice: "Benutzer #{@user.display_name} wurde entsperrt."
    else
      redirect_to admin_users_path, alert: "Benutzer konnte nicht entsperrt werden."
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :bio, :location, :website)
  end
end
