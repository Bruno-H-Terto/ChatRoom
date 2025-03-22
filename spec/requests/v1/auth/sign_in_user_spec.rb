require 'rails_helper'
include ActiveSupport::Testing::TimeHelpers

describe 'User sign in', type: :request do
  context 'POST api/v1/sign_in' do
    it 'with success' do
      user = User.create!(name: 'Test', email: 'test@email.com', password: '123456')
      session = user.create_session
      encode_token = JWT.encode(session.token, Rails.application.credentials.secret_key_base)
      allow(User).to receive(:find_by).and_return(user)
      allow(user).to receive(:create_session).and_return(session)
      allow(session).to receive(:encode_token).and_return(encode_token)

      post api_v1_sign_in_path, params: { email: 'test@email.com', password: '123456' }

      expect(response.status).to eq 201
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['token']).to eq encode_token
    end

    it 'should have correct fields' do
      user = User.create!(name: 'Test', email: 'test@email.com', password: '123456')

      post api_v1_sign_in_path, params: { email: 'test', password: 'something' }

      expect(response.status).to eq 401
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['error']).to eq 'Credenciais inválidas'
      expect(Session.count).to eq 0
    end

    it 'session expired at in 30 minutes after sign in' do
      user = User.create!(name: 'Test', email: 'test@email.com', password: '123456')
      current_time = Time.current
      session = user.create_session
      encode_token = JWT.encode(session.token, Rails.application.credentials.secret_key_base)
      allow(User).to receive(:find_by).and_return(user)
      allow(user).to receive(:create_session).and_return(session)
      allow(session).to receive(:encode_token).and_return(encode_token)

      post api_v1_sign_in_path, params: { email: 'test@email.com', password: '123456' }

      expect(response.status).to eq 201
      expect(response.content_type).to include 'application/json'
      session = user.session
      json_response = JSON.parse(response.body)
      expect(json_response['token']).to eq session.encode_token
      time_diff_in_seconds = session.expired_at - current_time
      time_diff_in_minutes = (time_diff_in_seconds / 60).to_i
      expect(time_diff_in_minutes).to eq 30
    end

    it 'session is destroied after 30 minutes of inactive' do
      user = User.create!(name: 'Test', email: 'test@email.com', password: '123456')
      session = user.create_session
      encode_token = JWT.encode(session.token, Rails.application.credentials.secret_key_base)
      allow(User).to receive(:find_by).and_return(user)
      allow(user).to receive(:create_session).and_return(session)
      allow(session).to receive(:encode_token).and_return(encode_token)
      headers = {
                  'ACCEPT' => 'application/json',
                  'Authorization' => "Bearer #{ encode_token }"
                }

      post api_v1_sign_in_path, params: { email: 'test@email.com', password: '123456' }
      travel_to 31.minutes.from_now
      get api_v1_root_path, headers: headers

      expect(response.status).to eq 401
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['error']).to eq 'Não autorizado'
      expect(json_response['_links']['sign_in']['href']).to eq 'http://www.example.com/api/v1/sign_in'
      expect(json_response['_links']['sign_in']['method']).to eq 'POST'
      expect(json_response['_links']['sign_up']['href']).to eq 'http://www.example.com/api/v1/sign_up'
      expect(json_response['_links']['sign_in']['method']).to eq 'POST'
      expect(Session.count).to eq 0
      travel_back
    end

    it 'sessions is updated in 30 minutes if user requests between time' do
      user = User.create!(name: 'Test', email: 'test@email.com', password: '123456')
      session = user.create_session
      expired_at_time = session.expired_at
      encode_token = JWT.encode(session.token, Rails.application.credentials.secret_key_base)
      allow(User).to receive(:find_by).and_return(user)
      allow(user).to receive(:create_session).and_return(session)
      allow(session).to receive(:encode_token).and_return(encode_token)
      headers = {
                  'ACCEPT' => 'application/json',
                  'Authorization' => "Bearer #{ encode_token }"
                }

      post api_v1_sign_in_path, params: { email: 'test@email.com', password: '123456' }
      travel_to 10.minutes.from_now
      get api_v1_root_path, headers: headers

      expect(session.reload.expired_at).not_to eq expired_at_time
      time_diff_in_seconds = session.expired_at - Time.current
      time_diff_in_minutes = (time_diff_in_seconds / 60).to_i
      expect(time_diff_in_minutes).to eq 30
      travel_back
    end
  end
end