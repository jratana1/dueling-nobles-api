class GameChannel < ApplicationCable::Channel
  def subscribed
      game= Room.find(params[:room_id]).game
      token = params[:jwt]
      current_user = current_user(token)

      # check to see if player 1 or 2
      if (game.player1.id == current_user.id)
         player="player1"
         opponent = game.player2
      else 
        player= "player2"
        opponent = game.player1
      end 

      game.status = "started"
      game.save

    stream_from "game_channel_#{game.id}_#{player}_#{current_user.id}"

    ActionCable
        .server
        .broadcast("chat_channel_#{(params[:room_id])}",
                   opponent: opponent.username,
                   game: game,
                   action: "started")
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
