class AddDetailsToGames < ActiveRecord::Migration[6.0]
  def change
    add_column :games, :status, :string, :default => "open"
  end
end
