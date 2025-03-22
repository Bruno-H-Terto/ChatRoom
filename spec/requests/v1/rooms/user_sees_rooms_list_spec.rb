require 'rails_helper'

describe 'User sees a rooms list', type: :request do
  context 'GET api/v1/' do
    it 'with success' do
      user = User.create!(name: 'Test', email: 'test@email.com', password: '123456')
      session = user.create_session
      expired_at_time = session.expired_at
      encode_token = JWT.encode(session.token, Rails.application.credentials.secret_key_base)
      allow(User).to receive(:find_by).and_return(user)
      allow(user).to receive(:create_session).and_return(session)
      allow(session).to receive(:encode_token).and_return(encode_token)
      romms = []
      3.times do |n|
        romms << Room.create(name: "Room #{ n +1 }")
      end
      session = user.create_session
      headers = {
                  'ACCEPT' => 'application/json',
                  'Authorization' => "Bearer #{ session.encode_token }"
                }

      get api_v1_root_path, headers: headers

      expect(response.status).to eq 200
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response.count).to eq 3
      expect(json_response[0]['name']).to eq 'Room 1'
      expect(json_response[1]['name']).to eq 'Room 2'
      expect(json_response[2]['name']).to eq 'Room 3'
    end

    it 'must be autheticated' do
      user = User.create!(name: 'Test', email: 'test@email.com', password: '123456')
      romms = []
      3.times do |n|
        romms << Room.create(name: "Room #{ n +1 }")
      end

      get api_v1_root_path

      expect(response.status).to eq 401
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['error']).to eq 'Não autorizado'
    end
  end
end
