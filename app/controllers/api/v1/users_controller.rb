class Api::V1::UsersController < ApplicationController
  before_action :authorized, only: :me
  def sign_in
    user = User.find_by(username: params[:username])

    unless params[:username] && params[:password]
      return render json: { status: 'error', message: 'Missing username or password' }, status: :unprocessable_entity
    end

    if user.authenticate(params[:password])
      token = encode_token({ user_id: user.id, exp: (Time.now + 30.minutes).to_i })
      render json: { 
        status: 'success', 
        data: { 
          user: user.as_json(
            only: [
              :id, 
              :username, 
              :name, 
              :type
            ]
          ), 
          token: token 
        } 
      }, status: :ok
    else
      render json: { status: 'error', message: 'Invalid username or password!' }, status: :unauthorized
    end
  end

  def me
    render json: { status: 'success', data: @user.as_json(
      only: [
        :id, 
        :username, 
        :name, 
        :type
      ]
    ) }, status: :ok
  end
end
