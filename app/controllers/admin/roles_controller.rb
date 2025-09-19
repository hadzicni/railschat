class Admin::RolesController < Admin::BaseController
  before_action :ensure_admin
  before_action :set_role, only: [ :show, :edit, :update, :destroy ]

  def index
    @roles = Role.all.order(:name)
    @users_count = {}
    @roles.each do |role|
      @users_count[role.id] = role.users.count
    end
  end

  def show
    @users = @role.users.includes(:roles).order(:first_name, :last_name, :email)
  end

  def new
    @role = Role.new
    @role.permissions = []
    @available_permissions = Role::PERMISSIONS
  end

  def create
    @role = Role.new(role_params)
    @available_permissions = Role::PERMISSIONS

    if @role.save
      redirect_to admin_roles_path, notice: t("admin.roles.created_successfully")
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @available_permissions = Role::PERMISSIONS
  end

  def update
    @available_permissions = Role::PERMISSIONS

    if @role.update(role_params)
      redirect_to admin_roles_path, notice: t("admin.roles.updated_successfully")
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    # Prevent deletion of system roles
    if Role::SYSTEM_ROLES.key?(@role.name)
      redirect_to admin_roles_path, alert: t("admin.roles.cannot_delete_system_role")
      return
    end

    if @role.users.any?
      redirect_to admin_roles_path, alert: t("admin.roles.cannot_delete_with_users")
      return
    end

    @role.destroy
    redirect_to admin_roles_path, notice: t("admin.roles.deleted_successfully")
  end

  def assign_role
    @user = User.find(params[:user_id])
    @role = Role.find(params[:role_id])

    if @user.add_role(@role.name)
      redirect_back(fallback_location: admin_users_path, notice: t("admin.roles.assigned_successfully"))
    else
      redirect_back(fallback_location: admin_users_path, alert: t("admin.roles.assignment_failed"))
    end
  end

  def remove_role
    @user = User.find(params[:user_id])
    @role = Role.find(params[:role_id])

    if @user.remove_role(@role.name)
      redirect_back(fallback_location: admin_users_path, notice: t("admin.roles.removed_successfully"))
    else
      redirect_back(fallback_location: admin_users_path, alert: t("admin.roles.removal_failed"))
    end
  end

  private

  def set_role
    @role = Role.find(params[:id])
  end

  def role_params
    params.require(:role).permit(:name, :description, :color, permissions: [])
  end

  def ensure_admin
    redirect_to root_path unless current_user&.can?("manage_roles")
  end
end
