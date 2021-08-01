class GameCreationEventBroadcastJob < ApplicationJob
    queue_as :default
  
    def perform(game)
      # channel = "chat_channel_267"

      # ActionCable
      #   .server
      #   .broadcast(channel,
      #              game: game,
      #              action: "create")
    end

  end