class AddUserIdToChatMessages < ActiveRecord::Migration[6.0]
  def change
    add_reference :chat_messages, :user, null: false, foreign_key: true
  end
end
