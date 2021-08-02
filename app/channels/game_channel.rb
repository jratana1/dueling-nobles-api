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
   
            stream_from "game_channel_#{game.id}_#{game.player_number(current_user)}"
          elsif (game.status === "started") 
            game.status = "playing"
            game.save

            stream_from "game_channel_#{game.id}_#{game.player_number(current_user)}"

            ActionCable
            .server
            .broadcast("game_channel_#{game.id}_player1",
                      game: {playerHand: game.player1_hand, opponentHand: game.player2_hand.length},
                      status: "playing"
                      action: "dealing")

            ActionCable
            .server
            .broadcast("game_channel_#{game.id}_player2",
                        game: {playerHand: game.player2_hand, opponentHand: game.player1_hand.length},
                        status: "playing"
                        action: "dealing")
          end
      end
      

      # else 
      #   player= "player2"
      #   opponent = game.player1

      #   game.status = "started"
      #   game.save
  
      #   stream_from "game_channel_#{game.id}_#{player}_#{current_user.id}"
  
      # ActionCable
      #     .server
      #     .broadcast("chat_channel_#{(params[:room_id])}",
      #                opponent: opponent.username,
      #                game: {playerHand: game.player2_hand, opponentHand: game.player1_hand.length, turn: game.turn},
      #                action: "started")
      # end 

    #   game.status = "started"
    #   game.save

    # stream_from "game_channel_#{game.id}_#{player}_#{current_user.id}"

    # ActionCable
    #     .server
    #     .broadcast("chat_channel_#{(params[:room_id])}",
    #                opponent: opponent.username,
    #                game: game,
    #                action: "started")
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def draw_card
  end
end
