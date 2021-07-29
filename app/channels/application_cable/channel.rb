module ApplicationCable
  class Channel < ActionCable::Channel::Base
    def decode_token(token)
      # JWT.decode(token, Rails.application.credentials.jwt[:secret])[0]
      JWT.decode(token, ENV['JWT_SECRET'])[0]
    end

    def current_user(token)
        user_id = decode_token(token)["user_id"]
        user = User.find_by(id: user_id)    
    end
  end
end
