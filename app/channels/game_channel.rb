class GameChannel < ApplicationCable::Channel
  def subscribed

      game= Room.find(params[:room_id]).game
      token = params[:jwt]
      current_user = current_user(token)
    stream_from "game_channel"
    ActionCable
        .server
        .broadcast("game_channel",
                   game: game,
                   action: "subscribed")
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
