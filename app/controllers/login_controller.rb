class LoginController < ApplicationController
  def index
    credentials = request.headers['Authorization'].split(':')
    user = User.find_by(name: credentials[0]).try(:authenticate, credentials[1])
    if user
      render json: {token: user.token}
    else
      render json: {errors: {login: 'Falsche Zugangsdaten'}}, status: :unauthorized
    end
  end
end
