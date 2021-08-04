class Game < ApplicationRecord
  belongs_to :room
  belongs_to :player1, :class_name => 'User', :foreign_key => 'player1_id', optional: true
  belongs_to :player2, :class_name => 'User', :foreign_key => 'player2_id', optional: true
  
  def deal_cards
    # self.draw_pile = self.draw_pile.shuffle
    self.player1_hand = self.draw_pile.pop(5)
    self.player2_hand = self.draw_pile.pop(5)
  end

  def reset_game
    self.draw_pile = (0..51).to_a
    self.player1_hand = []
    self.player2_hand = []
    self.discard_pile = []
    self.status = "open"
  end

  def player(current_user)
    
    (self.player1&.id === current_user.id) ? "player1" : "player2"
  end

  def opponent(current_user)
    (self.player1&.id === current_user.id) ? "player2" : "player1"
  end

  def player?(current_user)
    (self.player1&.id === current_user.id || self.player2&.id === current_user.id) ? true : false
  end

  def win?

  end
end
