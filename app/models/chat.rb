class Chat < ApplicationRecord
  belongs_to :room
  belongs_to :user_room

  validates :message, presence: true, length: { maximum: 140 }
end
