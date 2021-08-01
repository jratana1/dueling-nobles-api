class CreateGames < ActiveRecord::Migration[6.0]
  def change
    create_table :games do |t|
      t.integer :player1_id
      t.integer :player2_id

      t.timestamps
    end
  end
end
