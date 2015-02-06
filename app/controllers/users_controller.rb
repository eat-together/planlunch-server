class UsersController < ApplicationController

  def create
    user = User.new(user_params)
    user.save
    render json: {token: user.token}, status: :created
  end


  private

  def user_params
    params.require(:user).permit(:name, :email, :password)
  end

end
