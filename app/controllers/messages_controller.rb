class MessagesController < ApplicationController
  before_action :authenticate_user!

  # This controller is now primarily used as fallback
  # Main message sending happens via WebSocket in ChatChannel
  def create
    @room = Room.find(params[:room_id])
    @message = @room.messages.build(message_params)
    @message.user = current_user

    if @message.save
      # If JavaScript is disabled, still redirect normally
      redirect_to @room
    else
      @messages = @room.messages.includes(:user).order(created_at: :asc)
      render "rooms/show", status: :unprocessable_entity
    end
  end

  private

  def message_params
    params.require(:message).permit(:content)
  end
end
