class Book < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy

  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}

  # def favorited_by?(user)
  #   favorites.exists?(user_id: user.id)
    # favoritesにありますか？user_id: user.id
  # end

  # 多分同じ意味になってる
  # whereで引数部分にカラムのデータを指定していて、
  # それがありますか？となっている

  def favorited_by?(user)
    favorites.where(user_id: user.id).exists?
  end

  # レシーバのself(今回はclass Bookなのでsearchesコントローラの方でBook.serch_forで呼び出せる)
  def self.search_for(content, method)
    # perfectは、あとでビューの方でハッシュを使い
    # 完全一致というキーで取り出す
    if method == 'perfect'
    # ここでは取り出した物がmethodと同じならtrueで以下の処理をする
      Book.where(title: content)
    elsif method == 'forwerd'
      Book.where('title LIKE ?', content+'%')
    elsif method == 'backwerd'
      Book.where('title LIKE ?', '%'+content)
    else
      Book.where('title LIKE ?', '%'+content+'%')
    end
  end

end