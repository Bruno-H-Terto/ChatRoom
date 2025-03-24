require 'rails_helper'

describe 'User sends a message', type: :request do
  context 'POST api/v1/romms/:room_id/messages' do
    it 'with success' do
      user = User.create!(name: 'Test', email: 'test@email.com', password: '123456')
      room = Room.create(name: 'Room 1')

      post api_v1_room_messages_path(room), params: { 
          message: {
            user_id: user.id,
            body: 'Hello World!'
          }
       }, headers: authenticated_headers(user)

       expect(user.messages.count).to eq 1
       expect(user.messages.last.body).to eq 'Hello World!'
       expect(response.status).to eq 201
       expect(response.content_type).to include 'application/json'
       json_response = JSON.parse(response.body)
       expect(json_response['room_messages'].last['body']).to eq 'Hello World!'
    end

    it 'must be authenticated' do
      user = User.create!(name: 'Test', email: 'test@email.com', password: '123456')
      room = Room.create(name: 'Room 1')

      post api_v1_room_messages_path(room), params: { 
          message: {
            user_id: user.id,
            body: 'Hello World!'
          }
       }

       expect(user.messages.count).to eq 0
       expect(response.status).to eq 401
       expect(response.content_type).to include 'application/json'
       json_response = JSON.parse(response.body)
       expect(json_response['error']).to eq 'Não autorizado'
    end

    it 'mandatory fields' do
      user = User.create!(name: 'Test', email: 'test@email.com', password: '123456')
      room = Room.create(name: 'Room 1')

      post api_v1_room_messages_path(room), params: { 
          message: {
            user_id: '',
            body: ''
          }
       }, headers: authenticated_headers(user)

       expect(response.status).to eq 422
       expect(response.content_type).to include 'application/json'
       json_response = JSON.parse(response.body)
       expect(json_response['error']).to eq 'Usuário é obrigatório(a) e Corpo da mensagem não pode ficar em branco'
    end
  end
end