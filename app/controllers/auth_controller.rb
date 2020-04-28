class AuthController < ApplicationController
    skip_before_action :authorized, only: [:create]
    # ^ We are not requiring the Authorization header for the create method so a user can
    # create an account without being logged in.
 
  def create
    @user = User.find_by(username: user_login_params[:username])
   
    # User authenticate method comes from BCrypt.
    if @user && @user.authenticate(user_login_params[:password])
      # encode_token method comes from ApplicationController.
      @token = encode_token({ user_id: @user.id })
     
      # UserSerializer is a serializer in the serializers folder. To use this the active_model_serializers gem is needed.
      render json: { user: UserSerializer.new(@user), jwt: @token }, status: :accepted
     
    else
      render json: { message: 'Invalid username or password' }, status: :unauthorized
    end
  end
 

  private
 

  def user_login_params
    params.require(:user).permit(:username, :password)
  end
end