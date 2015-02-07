class LoginController < ApplicationController
  def index
    credentials = request.headers['Authorization'].split(':')
    user = User.where(name: credentials[0], password: credentials[1]).first
    if user.present?
      render json: {token: user.token}, status: :ok
    else
      render json: {}, status: :unauthorized
    end

  end
end
