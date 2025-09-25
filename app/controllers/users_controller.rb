class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [ :show, :edit, :update ]

  def show
  end

  def edit
  end

  def update
    if @user.update(user_params)
      log_activity(action: 'edit_profile', target: @user)
      redirect_to @user, notice: "Profil wurde erfolgreich aktualisiert."
    else
      render :edit
    end
  end

  private

  def set_user
    @user = params[:id] ? User.find(params[:id]) : current_user
  end

  def user_params
    params.require(:user).permit(:email, :first_name, :last_name, :bio, :location, :website)
  end
end
