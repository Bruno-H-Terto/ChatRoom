json.rooms @rooms do |room|
  json.room_name room.name
  json.messages room.messages do |message|
    json.id message.id
    json.body message.body
    json.user_id message.user_id
    json.room_id message.room_id
    json.created_at message.created_at
    json.updated_at message.updated_at
  end
end

json.messages "Nenhuma mensagem localizada" if @rooms.blank?
