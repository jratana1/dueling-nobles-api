class ChatChannel < ApplicationCable::Channel
  def subscribed
    if params[:room_id].present?
      # creates a private chat room with a unique name
      room = Room.find(params[:room_id])
      token = params[:jwt]
      current_user = current_user(token)
      # WIll push user to room

      stream_from("chat_channel_#{(params[:room_id])}")
    end

  end

  def unsubscribed

  end

  def speak(opts)
    token = opts.fetch('user')
    current_user = current_user(token)

    ChatMessage.create(content: opts.fetch('content'), user_id: current_user.id, room_id: opts.fetch('room_id'))
  end

  def join(opts) 
    game = Room.find(params[:room_id]).game
    token = params[:jwt]
    current_user = current_user(token)

    if (game.player1 && game.player2)
      ActionCable.server.broadcast("chat_channel_#{(params[:room_id])}", {players: {player1: game.player1.username, player2: game.player2.username}, action: "join" })
    elsif (game.player1)
      game.player2 = current_user

      ActionCable.server.broadcast("chat_channel_#{(params[:room_id])}", {players: {player1: game.player1.username, player2: game.player2.username}, action: "join" })
    elsif (game.player2)
      game.player1 = current_user

      ActionCable.server.broadcast("chat_channel_#{(params[:room_id])}", {players: {player1: game.player1.username, player2: game.player2.username}, action: "join" })
    else
      game.player1 = current_user
  
      ActionCable.server.broadcast("chat_channel_#{(params[:room_id])}", {players: {player1: game.player1.username, player2: ""}, action: "join" })
    end
    game.save
  end

  # def clear(opts)
  #   ActionCable.server.broadcast('chat_channel', { action: "clear" })
  # end

end
