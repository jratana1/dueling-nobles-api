class AddTurnCounterToGames < ActiveRecord::Migration[6.0]
  def change
    add_column :games, :turn, :integer, :default => 0
    add_column :games, :draw_pile, :integer, array: true, default: (0..51).to_a, null: false
    add_column :games, :discard_pile, :integer, array: true, default: [], null: false
    add_column :games, :player1_hand, :integer, array: true, default: [], null: false
    add_column :games, :player2_hand, :integer, array: true, default: [], null: false

  end
end
