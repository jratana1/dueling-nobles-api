class AddRoomIdToGames < ActiveRecord::Migration[6.0]
  def change
    add_column :games, :room_id, :integer
  end
end
