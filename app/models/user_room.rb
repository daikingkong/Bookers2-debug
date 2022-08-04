class UserRoom < ApplicationRecord
  # どのUserがどのRoomに所属しているかを判断するentryモデルがuser_room(あなたのルーム=roomからみたあなた）
  belongs_to :user
  belongs_to :room
end
