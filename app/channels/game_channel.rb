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

            ActionCable
            .server
            .broadcast("game_channel_#{game.id}_#{game.player(current_user)}",
                      playerHand: game.send("#{game.player(current_user)}_hand"), 
                      opponentHand: game.send("#{game.opponent(current_user)}_hand").length,
                      status: game.status,
                      turn: game.turn,
                      seat: game.player(current_user),
                      status: "playing",
                      action: "dealing")

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
                      seat: game.opponent(current_user),
                      status: "playing",
                      action: "dealing")

            ActionCable
            .server
            .broadcast("game_channel_#{game.id}_#{game.opponent(current_user)}",
                        playerHand: game.send("#{game.opponent(current_user)}_hand"), 
                        opponentHand: game.send("#{game.player(current_user)}_hand").length,
                        status: game.status,
                        turn: game.turn,
                        seat: game.player(current_user),
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

  def draw(opts)

    game= Room.find(params[:room_id]).game
    token = params[:jwt]
    current_user = current_user(token)
    card = opts.fetch('card')


    if (card["location"] == "drawPile")
        card["card"]["image"]= game.draw_pile.pop()
        game.send("#{game.player(current_user)}_hand") << card["card"]["image"]
        game.turn = game.turn + 1


    elsif (card["location"] == "playerHand")
      game.turn = game.turn + 1
        if (game.player(current_user) == "player1")
            updatedPlayerHand = game.send("#{game.player(current_user)}_hand") - [card["card"]["image"]]
            game.discard_pile.push([card["card"]["image"]][0])
            game.player1_hand = updatedPlayerHand
      
        elsif (game.player(current_user) == "player2")
            updatedPlayerHand = game.send("#{game.player(current_user)}_hand") - [card["card"]["image"]]
            game.discard_pile.push([card["card"]["image"]][0])
            game.player2_hand = updatedPlayerHand
        end

      
    elsif (card["location"] == "discardPile")
      newDiscardPile = game.discard_pile - [card["card"]["image"]]
      game.discard_pile = newDiscardPile
      game.send("#{game.player(current_user)}_hand") << card["card"]["image"]
      game.turn = game.turn + 1
    end
    game.save
    ActionCable
    .server
    .broadcast("game_channel_#{game.id}_#{game.player(current_user)}",
              playerHand: game.send("#{game.player(current_user)}_hand"), 
              opponentHand: game.send("#{game.opponent(current_user)}_hand").length,
              discardPile: game.discard_pile,
              turn: game.turn,
              card: card,
              player: "player",
              action: "drawing")

    ActionCable
    .server
    .broadcast("game_channel_#{game.id}_#{game.opponent(current_user)}",
                playerHand: game.send("#{game.opponent(current_user)}_hand"), 
                opponentHand: game.send("#{game.player(current_user)}_hand").length,
                discardPile: game.discard_pile,
                turn: game.turn,
                card: card,
                player: "opponent",
                action: "drawing")

  end
end
