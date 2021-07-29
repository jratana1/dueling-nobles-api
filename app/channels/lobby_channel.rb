class LobbyChannel < ApplicationCable::Channel
  def subscribed
    stream_from "lobby_channel"

  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak
    user = User.find_by(username: opts.fetch('user'))
    # Lobby is room_id 267
    ChatMessage.create(content: opts.fetch('content'), user_id: user.id, room_id:267)
  end
end
