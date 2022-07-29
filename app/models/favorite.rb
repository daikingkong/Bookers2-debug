class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :book
  validates_uniqueness_of :book_id, scope: :user_id
  #  validates :book_id, uniqueness: trueは
  # book_idは唯一の存在でなければ制限されるということ
  # しかし今回は複数の人が同じbook_idを取得することが必要なため（どの投稿のいいねかを紐づけるため)
  # book_idは重複して取得できるようにしておく必要がある
  # これだと一つのbookに
  # すべてユーザーのうち誰かが
  # いいねするとそれ以上誰もいいねできない

  # そこでvalidates_uniqueness_ofによって
  # book_idが一意である制約をつけたあと
  # scope: で範囲を絞る
  # user_id（そのユーザーに対してのみ）
end
