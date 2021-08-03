class RoomCreationEventBroadcastJob < ApplicationJob
    queue_as :default
  
    def perform(room)
      lobby = Room.find_by(name: "lobby")

      channel = "chat_channel_#{lobby.id}"

      ActionCable
        .server
        .broadcast(channel,
                   room: room,
                   action: "create")
    end

end