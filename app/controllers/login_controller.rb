class LoginController < ApplicationController
  def index
    user = User.where(name: params[:name], password: params[:password]).first
    if user.present?
      render json: {token: user.token}, status: :ok
    else
      render json: {}, status: :unauthorized
    end

  end
end
