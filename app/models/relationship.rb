class Relationship < ApplicationRecord
  # １ユーザーは多ユーザーにフォローもできる(follower)し、
  # フォローもされる(followed)ので、どちらにもbelongs_to(属する)
  # そのままだとfollowerテーブルとfollowedテーブルを探しに行ってしまうので
  # userテーブルからデータをとってきてもらうためにclass_name: "User"にします。
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"
  # フォローをした、されたの関係
  # class_name: "Relationship"でRelationshipテーブルを参照します。
  # foreign_key(外部キー)で参照するカラムを指定
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  # 一覧画面で使う
  # user.followersという記述でフォロワーを表示したいので、
  # throughでスルーするテーブル、sourceで参照するカラムを指定。
  has_many :followings, through: :relationship, source: :followed
  has_many :followers, through: :reverse_of_relationship, source: :follower
  # 上の例では、reverse_of_relationshipsテーブルからfollower_idのデータを参照します。
end
