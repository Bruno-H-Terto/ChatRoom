class Api::V1::RoomsController < ApplicationController
  before_action :authentication!
  def index
    rooms = Room.all
    render json: sanitizer_response(rooms)
  end

  def create
    room = Room.new(room_params)
    if room.save
      return render json: { room: sanitizer_response(room) }, status: :created
    end

    render json: { error: room.errors.full_messages.to_sentence }, status: :unprocessable_entity
  end

  private

  def room_params
    params.require(:room).permit(:name)
  end
end