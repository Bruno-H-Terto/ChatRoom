class Api::V1::MessagesController < ApplicationController
  before_action :authentication!

  def index
    room = Room.find(params[:room_id])
    render json: { messages: room.messages }, status: :ok
  end

  def create
    room = Room.find(params[:room_id])
    message = room.messages.build(message_params)
    if message.save
      return render json: { room_messages: room.messages }, status: :created
    end

    render json: { error: message.errors.full_messages.to_sentence }, status: :unprocessable_entity
  end

  def history
    user = User.find(params[:user_id])
    @rooms = user.rooms
  end

  private

  def message_params
    params.require(:message).permit(:user_id, :body)
  end
end
