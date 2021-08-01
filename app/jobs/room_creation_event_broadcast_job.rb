class RoomCreationEventBroadcastJob < ApplicationJob
    queue_as :default
  
    def perform(room)
      channel = "chat_channel_267"

      ActionCable
        .server
        .broadcast(channel,
                   room: room,
                   action: "create")
    end

end