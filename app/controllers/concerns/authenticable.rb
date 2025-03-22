module Authenticable
  def valid_session?
    token = request.headers["Authorization"]&.split(" ")&.last
    return false unless token

    decoded = decode_token(token)
    session = Session.find_by(token: decoded[0])
    return false unless session

    if session.expired_at < Time.current
      session.destroy!
      false
    else
      session.update(expired_at: 30.minutes.from_now)
      true
    end
  end

  def decode_token(token)
    begin
      ::JWT.decode(token, Rails.application.credentials.secret_key_base)
    rescue ::JWT::DecodeError
      nil
    end
  end

  def authentication!
    unless valid_session?
      render json: {
        error: "Não autorizado",
        _links: {
          sign_in: {
            href: api_v1_sign_in_url,
            method: "POST"
          },
          sign_up: {
            href: api_v1_sign_up_url,
            method: "POST"
          }
        }
      }, status: :unauthorized
    end
  end
end
