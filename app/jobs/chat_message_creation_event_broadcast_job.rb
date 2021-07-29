class ChatMessageCreationEventBroadcastJob < ApplicationJob
    queue_as :default
  
    def perform(chat_message)

      ActionCable
        .server
        .broadcast("#{chat_message.room.name}_channel",
                   id: chat_message.id,
                   created_at: chat_message.created_at.strftime('%H:%M'),
                   content: chat_message.content,
                   username: chat_message.user.username,
                   action: "chat")
    end


    # queue_as :default

    # def perform(message)
    #   payload = {
    #     room_id: message.conversation.id,
    #     content: message.content,
    #     sender: message.sender,
    #     participants: message.conversation.users.collect(&:id)
    #   }
    #   ActionCable.server.broadcast(build_room_id(message.conversation.id), payload)
    # end
    
    # def build_room_id(id)
    #   "ChatRoom-#{id}"
    # end
  end