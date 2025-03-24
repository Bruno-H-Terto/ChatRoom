require 'rails_helper'

describe 'User sees message history', type: :request do
  context 'GET api/v1/room/:romm_id/messages' do
    it 'of a room' do
      first_user = User.create!(name: 'Test 1', email: 'test@email.com', password: '123456')
      second_user = User.create!(name: 'Test 2', email: 'other@email.com', password: '123456')
      room = Room.create!(name: 'Room 1')
      first_user.messages.create!(room: room, body: 'Hello Test 2')
      second_user.messages.create!(room: room, body: 'Hi Test 1, how are you?')

      get api_v1_room_messages_path(room), headers: authenticated_headers(first_user)

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['messages']).to eq room.messages.as_json
    end

    it 'must be authenticated' do
      first_user = User.create!(name: 'Test 1', email: 'test@email.com', password: '123456')
      second_user = User.create!(name: 'Test 2', email: 'other@email.com', password: '123456')
      room = Room.create!(name: 'Room 1')
      first_user.messages.create!(room: room, body: 'Hello Test 2')
      second_user.messages.create!(room: room, body: 'Hi Test 1, how are you?')

      get api_v1_room_messages_path(room)

      expect(response.status).to eq 401
      json_response = JSON.parse(response.body)
      expect(json_response['error']).to eq 'Não autorizado'
    end
  end

  context 'GET api/v1/messages/:user_id' do
    it 'sends and receives' do
      first_user = User.create!(name: 'Test 1', email: 'test@email.com', password: '123456')
      second_user = User.create!(name: 'Test 2', email: 'other@email.com', password: '123456')
      first_room = Room.create!(name: 'Room 1')
      first_user.messages.create!(room: first_room, body: 'Hello Test 2')
      second_user.messages.create!(room: first_room, body: 'Hi Test 1, how are you?')

      second_room = Room.create!(name: 'Room 2')
      first_user.messages.create!(room: second_room, body: 'Hello World!')

      third_room = Room.create!(name: 'Room 3')
      second_user.messages.create!(room: third_room, body: 'Other message')

      get api_v1_messages_path(user_id: first_user.id), headers: authenticated_headers(first_user)

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      expected_messages = [
        {
          "room_name" => "Room 1",
          "messages" => first_room.messages.map do |message|
            {
              "id" => message.id,
              "body" => message.body,
              "user_id" => message.user_id,
              "room_id" => message.room_id,
              "created_at" => message.created_at.as_json,
              "updated_at" => message.updated_at.as_json
            }
          end
        },
        {
          "room_name" => "Room 2",
          "messages" => second_room.messages.map do |message|
            {
              "id" => message.id,
              "body" => message.body,
              "user_id" => message.user_id,
              "room_id" => message.room_id,
              "created_at" => message.created_at.as_json,
              "updated_at" => message.updated_at.as_json
            }
          end
        }
      ]
      json_response = JSON.parse(response.body)
      expect(json_response['rooms']).to eq expected_messages
    end

    it 'and not found messages' do
      user = User.create!(name: 'Test 1', email: 'test@email.com', password: '123456')

      get api_v1_messages_path(user_id: user.id), headers: authenticated_headers(user)

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['messages']).to eq "Nenhuma mensagem localizada"
    end
  end
end