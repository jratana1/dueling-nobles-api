class Game < ApplicationRecord
  belongs_to :room
  belongs_to :player1, :class_name => 'User', :foreign_key => 'player1_id', optional: true
  belongs_to :player2, :class_name => 'User', :foreign_key => 'player2_id', optional: true

    # after_create_commit do
    #     GameCreationEventBroadcastJob.perform_later(self)
    # end
end
