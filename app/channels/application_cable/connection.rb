module ApplicationCable
  class Connection < ActionCable::Connection::Base
    identified_by :uuid
    # identified_by :current_user

    def connect
      self.uuid = SecureRandom.uuid
      # self.current_user = find_verified_user
    end

    protected

    def find_verified_user # this checks whether a user is authenticated with devise
   

    end
  end
end
