class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: [ :show, :edit, :update ]
  before_action :check_user_authorization, only: [ :edit, :update ]

  def show
  end

  def edit
  end

  def update
    if @user.update(user_params)
      log_activity(action: 'profile_update', target: @user)
      redirect_to @user, notice: "Profil wurde erfolgreich aktualisiert."
    else
      render :edit
    end
  end

  private

  def set_user
    @user = params[:id] ? User.find(params[:id]) : current_user
  end

  def check_user_authorization
    unless @user == current_user || current_user.admin?
      redirect_to root_path, alert: "Sie sind nicht berechtigt, dieses Profil zu bearbeiten."
    end
  end

  def user_params
    params.require(:user).permit(:email, :first_name, :last_name, :bio, :location, :website)
  end
end
