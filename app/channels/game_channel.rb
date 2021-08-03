class GameChannel < ApplicationCable::Channel
  def subscribed
      game= Room.find(params[:room_id]).game
      token = params[:jwt]
      current_user = current_user(token)

      # check to see if player 1 or 2
      if (game.player?(current_user))
          if (game.status === "open")
            game.status = "started"
            game.deal_cards
            game.save

            ActionCable
            .server
            .broadcast("chat_channel_#{(params[:room_id])}",
                      action: "started")
   
            stream_from "game_channel_#{game.id}_#{game.player(current_user)}"

          elsif (game.status === "started") 
            game.status = "playing"
            game.save

            stream_from "game_channel_#{game.id}_#{game.player(current_user)}"

            ActionCable
            .server
            .broadcast("game_channel_#{game.id}_#{game.player(current_user)}",
                      playerHand: game.send("#{game.player(current_user)}_hand"), 
                      opponentHand: game.send("#{game.opponent(current_user)}_hand").length,
                      status: game.status,
                      turn: game.turn,
                      status: "playing",
                      action: "dealing")

            ActionCable
            .server
            .broadcast("game_channel_#{game.id}_#{game.opponent(current_user)}",
                        playerHand: game.send("#{game.opponent(current_user)}_hand"), 
                        opponentHand: game.send("#{game.player(current_user)}_hand").length,
                        status: game.status,
                        turn: game.turn,
                        status: "playing",
                        action: "dealing")
          else
            stream_from "game_channel_#{game.id}_#{game.player(current_user)}"
          end
      end
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def draw

    game= Room.find(params[:room_id]).game
    token = params[:jwt]
    current_user = current_user(token)

    card = game.draw_pile.pop()
    game.send("#{game.player(current_user)}_hand") << card
    game.turn = game.turn + 1
    game.save

    ActionCable
    .server
    .broadcast("game_channel_#{game.id}_#{game.player(current_user)}",
              playerHand: game.send("#{game.player(current_user)}_hand"), 
              opponentHand: game.send("#{game.opponent(current_user)}_hand").length,
              turn: game.turn,
              player: "player",
              action: "drawing")

    ActionCable
    .server
    .broadcast("game_channel_#{game.id}_#{game.opponent(current_user)}",
                playerHand: game.send("#{game.opponent(current_user)}_hand"), 
                opponentHand: game.send("#{game.player(current_user)}_hand").length,
                turn: game.turn,
                player: "opponent",
                action: "drawing")

  end
end
