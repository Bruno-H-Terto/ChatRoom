class Api::V1::SessionsController < ApplicationController
  def sign_in
    user = User.find_by(email: params[:email])

    if user&.authenticate(params[:password])
      session = user.create_session
      render json: { token: session.encode_token }, status: :created
    else
      render json: { error: 'Credenciais inválidas' }, status: :unauthorized
    end
  end

  def sign_up
    user = User.new(user_params)

    if user.save
      return render json: { result: I18n.t('.success') }, status: :created
    end

    render json: { error: user.errors.full_messages.to_sentence }, status: :unprocessable_entity
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end
end
