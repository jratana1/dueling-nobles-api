class ChatMessageCreationEventBroadcastJob < ApplicationJob
    queue_as :default
  
    def perform(chat_message)
      channel = "chat_channel_#{chat_message.room.id}"

      ActionCable
        .server
        .broadcast(channel,
                   id: chat_message.id,
                   created_at: chat_message.created_at.strftime('%H:%M'),
                   content: chat_message.content,
                   username: chat_message.user.username,
                   action: "chat")
    end

  end