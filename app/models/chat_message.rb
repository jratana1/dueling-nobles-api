class ChatMessage < ApplicationRecord
  belongs_to :room
  belongs_to :user

  validates_presence_of :content

  after_create_commit do
      ChatMessageCreationEventBroadcastJob.perform_later(self)
  end
end
