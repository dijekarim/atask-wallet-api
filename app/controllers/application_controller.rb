class ApplicationController < ActionController::API
  def encode_token(payload)
    JWT.encode(payload, ENV['JWT_SECRET']) 
  end

  def decoded_token
    header = request.headers['Authorization']
    if header
      token = header.split(" ")[1]
      begin
        JWT.decode(token, ENV['JWT_SECRET'], true, algorithm: 'HS256')
      rescue JWT::DecodeError
        nil
      end
    end
  end

  def current_user 
    if decoded_token
      user_id = decoded_token[0]['user_id']
      @user = User.find_by(id: user_id)
    end
  end

  def authorized_user
    unless !!current_user
    render json: { status: 'error', message: 'Please log in' }, status: :unauthorized
    end
  end
end
