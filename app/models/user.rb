class User < ApplicationRecord
    has_and_belongs_to_many :rooms, dependent: :destroy
    has_many :games
    # Cant call user.games need to call
    # Game.where("player1_id = ? OR player2_id = ?", 1, 1)
end

