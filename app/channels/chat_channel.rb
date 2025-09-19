class ChatChannel < ApplicationCable::Channel
  def subscribed
    room = Room.find(params[:room_id])
    stream_for room
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def send_message(data)
    room = Room.find(params[:room_id])
    user = current_user

    message = room.messages.create!(
      content: data["content"],
      user: user
    )

    ChatChannel.broadcast_to(room, {
      message: render_message(message, user),
      user_email: user.email,
      created_at: message.created_at.strftime("%H:%M")
    })
  end

  private

  def render_message(message, current_user)
    ApplicationController.render(
      partial: "messages/message",
      locals: { message: message, current_user_id: current_user.id }
    )
  end
end
