class RoomsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_room, only: [ :show ]

  def index
    @rooms = Room.all
    @room = Room.new
  end

  def show
    @messages = @room.messages.includes(:user).order(created_at: :asc)
    @message = Message.new
    log_activity(action: 'join_room', target: @room)
  end

  def new
    @room = Room.new
  end

  def create
    @room = Room.new(room_params)

    if @room.save
      log_activity(action: 'create_room', target: @room)
      redirect_to rooms_path, notice: "Chatraum wurde erfolgreich erstellt."
    else
      @rooms = Room.all
      render :index, status: :unprocessable_entity
    end
  end

  private

  def set_room
    @room = Room.find(params[:id])
  end

  def room_params
    params.require(:room).permit(:name, :description)
  end
end
