module AuthHelper
  def authenticated_headers(user)
    session = user.create_session
    token = JWT.encode(session.token, Rails.application.credentials.secret_key_base)

    {
      'ACCEPT' => 'application/json',
      'Authorization' => "Bearer #{token}"
    }
  end
end
