class Admin::UsersController < Admin::BaseController
  before_action :set_user, only: [ :show, :edit, :update, :destroy, :ban_user, :unban_user, :assign_role, :remove_role ]

  def index
    @users = User.includes(:messages, :roles).order(:email)
    @total_users = @users.count
    @admin_users = User.joins(:roles).where(roles: { name: "admin" }).count
    @regular_users = @total_users - @admin_users
    @banned_users = @users.banned_users.count
    @roles = Role.all.order(:name)
  end

  def show
    @user_messages = @user.messages.includes(:room).order(created_at: :desc).limit(10)
    @user_rooms = Room.joins(:messages).where(messages: { user: @user }).distinct.limit(5)
    @available_roles = Role.all.order(:name)
    @user_roles = @user.roles.order(:name)
  end

  def new
    @user = User.new
    @generated_password = generate_random_password
  end

  def create
    @user = User.new(user_params)
    @generated_password = params[:generated_password]
    @user.password = @generated_password
    @user.password_confirmation = @generated_password

    if @user.save
      redirect_to admin_user_path(@user), notice: "Benutzer erfolgreich erstellt. Temporäres Passwort: #{@generated_password}"
    else
      render :new, status: :unprocessable_entity
    end
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

  def assign_role
    @role = Role.find(params[:role_id])

    if @user.can_have_roles_modified_by?(current_user)
      if @user.add_role(@role.name)
        redirect_to admin_user_path(@user), notice: "Rolle '#{@role.name}' wurde #{@user.display_name} zugewiesen."
      else
        redirect_to admin_user_path(@user), alert: "Rolle konnte nicht zugewiesen werden."
      end
    else
      redirect_to admin_user_path(@user), alert: "Du hast keine Berechtigung, Rollen zu bearbeiten."
    end
  end

  def remove_role
    @role = Role.find(params[:role_id])

    if @user.can_have_roles_modified_by?(current_user)
      if @user.remove_role(@role.name)
        redirect_to admin_user_path(@user), notice: "Rolle '#{@role.name}' wurde von #{@user.display_name} entfernt."
      else
        redirect_to admin_user_path(@user), alert: "Rolle konnte nicht entfernt werden."
      end
    else
      redirect_to admin_user_path(@user), alert: "Du hast keine Berechtigung, Rollen zu bearbeiten."
    end
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

  def generate_random_password
    # Generate a random password with letters, numbers and special characters
    charset = ("a".."z").to_a + ("A".."Z").to_a + (0..9).to_a + [ "!", "@", "#", "$", "%" ]
    Array.new(12) { charset.sample }.join
  end
end
