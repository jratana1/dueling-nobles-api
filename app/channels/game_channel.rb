class GameChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "game_channel"
    if params[:room_id].present?
      # creates a private chat room with a unique name
      stream_from("game_channel_#{(params[:room_id])}")
    end

  end

  def unsubscribed; end

  def speak(opts)

    token = opts.fetch('user')
    current_user = current_user(token)

    ChatMessage.create(content: opts.fetch('content'), user_id: current_user.id, room_id: opts.fetch('room_id'))
  end

  # def draw(opts) 
  #   ActionCable.server.broadcast('chat_channel', { cell: opts.fetch("cell"), action: "draw" })
  # end

  # def answer(opts)
  #   Answer.create(
  #     answer: opts.fetch('answer')
  #   )
  #   # ActionCable.server.broadcast('chat_channel', { answer: opts.fetch("answer"), action: "answer" })

  # end

  # def clear(opts)
  #   ActionCable.server.broadcast('chat_channel', { action: "clear" })
  # end

end
