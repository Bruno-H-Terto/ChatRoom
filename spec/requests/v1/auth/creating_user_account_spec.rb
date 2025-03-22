require 'rails_helper'

describe 'Creating user account', type: :request do
  context 'POST api/v1/sign_up' do
    it 'with success' do
      post api_v1_sign_up_path, params:
                              { user:
                                {
                                  email: 'test@email.com',
                                  password: '123456',
                                  name: 'Test user'
                                }
                              }

      user = User.last
      expect(User.count).to eq 1
      expect(user.name).to eq 'Test user'
      expect(user.email).to eq 'test@email.com'
      expect(response.status).to eq 201
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['result']).to eq 'Usuário cridado com sucesso!'
    end

    it 'mandatory fields' do
      post api_v1_sign_up_path, params:
      { user:
        {
          email: '',
          password: '',
          name: ''
        }
      }

      expect(User.count).to eq 0
      expect(response.status).to eq 422
      expect(response.content_type).to include 'application/json'
      json_response = JSON.parse(response.body)
      expect(json_response['error']).to eq 'Senha não pode ficar em branco, Nome não pode ficar em branco, E-mail não pode ficar em branco e E-mail não é válido'
    end
  end
end
