class Book < ApplicationRecord
  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy
  has_many :favorited_users, through: :favorites, source: :user
  has_many :view_counts, dependent: :destroy

  validates :title,presence:true
  validates :body,presence:true,length:{maximum:200}

  scope :created_today, -> { where(created_at: Time.zone.now.all_day) }
  scope :created_yesterday, -> { where(created_at: 1.day.ago.all_day) }
  scope :created_this_week, -> { where(created_at: 6.day.ago.beginning_of_day..Time.zone.now.end_of_day) }
  scope :created_last_week, -> { where(created_at: 2.week.ago.beginning_of_day..1.week.ago.end_of_day) }

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
      # 前方一致(から始まる)：検索値%
    elsif method == 'backwerd'
      Book.where('title LIKE ?', '%'+content)
      #  後方一致(で終わる)：%検索値
    else
      Book.where('title LIKE ?', '%'+content+'%')
      # モデルクラス.where("列名 LIKE ?", "%値%")は、値(文字列)を含む
      # モデルクラス.where("列名 LIKE ?", "値_")は、値(文字列)と末尾の1文字
      # 「?」はプレースホルダと言うもので、第2引数の値を「?」へ置き換えるための目印です。
      # SQLインジェクションなどのセキュリティリスクを防ぐ働きもあります。
    end
  end

end