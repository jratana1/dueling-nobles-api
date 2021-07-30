class GameChannel < ApplicationCable::Channel
  def subscribed
    # stream_from "game_channel"
    if params[:room_id].present?
      # creates a private chat room with a unique name
      stream_from("game_channel_#{(params[:room_id])}")
    end
    # stream_from "game_channel_#{uuid}"
    # Room.create(name: "game_channel_#{uuid}")
    # ActionCable.server.broadcast("game_channel_#{uuid}", action: 'subscribed', channel: "game_channel_#{uuid}")

  end

  def unsubscribed; end

  def create(opts)
    user = User.find_by(username: opts.fetch('user'))
    room = Room.find_by(name: opts.fetch('room'))

    ChatMessage.create(content: opts.fetch('content'), user_id: user.id, room_id:room.id)
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
