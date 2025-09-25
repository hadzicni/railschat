class MessagesController < ApplicationController
  before_action :authenticate_user!
  before_action :check_send_permission

  # This controller is now primarily used as fallback
  # Main message sending happens via WebSocket in ChatChannel
  def create
    @room = Room.find(params[:room_id])
    @message = @room.messages.build(message_params)
    @message.user = current_user

    if @message.save
      log_activity('message_send', @message, "Nachricht gesendet in Raum: #{@room.name}")
      # If JavaScript is disabled, still redirect normally
      redirect_to @room
    else
      @messages = @room.messages.includes(:user).order(created_at: :asc)
      render "rooms/show", status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:content, :reply_to_id)
  end

  def check_send_permission
    unless current_user.can?("send_messages")
      redirect_to root_path, alert: "Sie haben keine Berechtigung, Nachrichten zu senden."
    end
  end
end
