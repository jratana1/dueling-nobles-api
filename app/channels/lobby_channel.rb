class LobbyChannel < ApplicationCable::Channel
  def subscribed
    stream_from "lobby_channel"

  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def speak(opts)
    token = opts.fetch('user')
    current_user = current_user(token)
    # Lobby is room_id 267
    ChatMessage.create(content: opts.fetch('content'), user_id: current_user.id, room_id:267)
  end
end
