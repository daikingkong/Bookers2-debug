class Relationship < ApplicationRecord
  # １ユーザーは多ユーザーにフォローもできる(follower)し、
  # フォローもされる(followed)ので、どちらにもbelongs_to(属する)
  # そのままだとfollowerテーブルとfollowedテーブルを探しに行ってしまうがそんなもんは無いので
  # しっかりとuserテーブルからデータをとってきてもらうためにclass_name: "User"にします。
  belongs_to :follower, class_name: "User"
  belongs_to :followed, class_name: "User"
  # Relationship側から見て、Userは1対多
  # しかし、今回Userの中でもフォローする側、される側の2種類がある為
  # 2つ記述する(する側される側で分ける）
  # しかしそのままだとUserテーブルではなく、存在しないテーブルを参照しようとしてエラーエラーになるので
  # しっかりとUserテーブルを参照する為に
  # class_nameでUserとする。(参照先は同じ）
end
