class AddRoomIdToChatMessages < ActiveRecord::Migration[6.0]
  def change
    add_reference :chat_messages, :room, null: false, foreign_key: true
  end
end
