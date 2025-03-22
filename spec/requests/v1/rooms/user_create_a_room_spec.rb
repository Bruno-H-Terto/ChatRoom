require 'rails_helper'

describe 'User create a room', type: :request do
  context 'POST api/v1/rooms' do
    def sanitizer_response(object)
      object.as_json(
        except: [ :created_at, :updated_at ]
        )
    end

    it 'with success' do
      user = User.create!(name: 'Test', email: 'test@email.com', password: '123456')

      post api_v1_rooms_path, params: { room: { name: 'Room 1' } }, headers: authenticated_headers(user)

      expect(Room.count).to eq 1
      room = Room.last
      expect(room.name).to eq 'Room 1'
      expect(response.status).to eq 201
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['room']).to eq sanitizer_response(room)
    end

    it 'must be authenticated' do
      user = User.create!(name: 'Test', email: 'test@email.com', password: '123456')

      post api_v1_rooms_path, params: { room: { name: 'Room 1' } }

      expect(Room.count).to eq 0
      expect(response.status).to eq 401
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['error']).to eq 'Não autorizado'
    end

    it 'mandatory fields' do
      user = User.create!(name: 'Test', email: 'test@email.com', password: '123456')

      post api_v1_rooms_path, params: { room: { name: '' } }, headers: authenticated_headers(user)

      expect(Room.count).to eq 0
      expect(response.status).to eq 422
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['error']).to eq 'Nome não pode ficar em branco'
    end
  end
end
