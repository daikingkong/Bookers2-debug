class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :books, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :book_comments, dependent: :destroy

# ユーザーは多くの部屋に所属できる。
# ・チャットルームは多くのユーザー（今回はＤＭなので二人ですが）が所属している。
# これは多対多ですね。
# # 先ほども申しましたが今回はUser_Roomテーブルを中間テーブルとしています。
# # UserRoomテーブルの情報を参照してデータのやり取りをしていると思います。
  has_many :chats, dependent: :destroy
  has_many :user_rooms, dependent: :destroy
  has_many :rooms, through: :user_rooms, dependent: :destroy

  has_many :view_counts, dependent: :destroy

  has_many :group_users, dependent: :destroy
  has_many :groups, through: :group_users

  # フォローをした、されたの関係
  # UserからみてRelationshipは多対１
  # しかし、今回Relationshipの中でもUserに対し2種類記述した為
  # 2つ記述する(する側される側で分ける）
  # しかしこのままだと存在しないテーブルを参照しようとするので
  # しっかりとRelationshipを参照する為に
  # class_name: "Relationship"でRelationshipテーブルを参照します。
  # さらに、has_manyのどっちがbelongs_toのどっちと紐づくのかが分からないので
  # フォローする側、される側のどちらのカラムを参照するかをforeign_key(外部キー)で指定(入口から入る鍵）
  # する側
  has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
  # される側
  has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy
  # ここまででアソシエーションはできた

  # 一覧画面で(User.followers)などと使うときに、
  # throughでスルーするテーブル、sourceで参照するカラムを指定。
  # する側がrelationships(中間テーブル)を通して、される側すべてをとってくる（source)（出口）
  has_many :followings, through: :relationships, source: :followed
  # される側がreverse_of_relationships(中間テーブル)を通して、する側すべてをとってくる（source)
  has_many :followers, through: :reverse_of_relationships, source: :follower
  # 上の例では、reverse_of_relationshipsを越えて、relationshipからfollower_idのデータを参照します。
  has_one_attached :profile_image

  validates :name, length: { minimum: 2, maximum: 20 }, uniqueness: true
  validates :introduction, length: {maximum: 50 }


  # コントローラを簡単に記述する為、ここでメソッドを用意し、後で呼び出せるようにする
  # 注意すべき点は、フォローが自分自身ではないか？とすでにフォローしていないか？の２点です
  # フォローしたときの処理
  # フォローするとき
  # followed_idと
  # follower_idが必要

  # まずは
  # ユーザーをフォローする
  def follow(user_id)
    relationships.create(followed_id: user_id)
  end

  # ユーザーのフォローを外す
  def unfollow(user_id)
    relationships.find_by(followed_id: user_id).destroy
  end

  # フォローしているか判定
  def following?(user)
    followings.include?(user)
    # include?(含めますか？=>userを）
  end

  def get_profile_image
    (profile_image.attached?) ? profile_image : 'no_image.jpg'
  end

  def self.search_for(content, method)
    # perfectは、あとでビューの方でハッシュを使い
    # 完全一致というキーで取り出す
    if method == 'perfect'
    # ここでは取り出した物がmethodと同じならtrueで以下の処理をする
      User.where(name: content)
    elsif method == 'forwerd'
      User.where('name LIKE ?', content+'%')
    elsif method == 'backwerd'
      User.where('name LIKE ?', '%'+content)
    else
      User.where('name LIKE ?', '%'+content+'%')
    end
  end

  def self.guest
    find_or_create_by!(name: 'guestuser' ,email: 'guest@example.com') do |user|
      user.password = SecureRandom.urlsafe_base64
      user.name = "guestuser"
    end
  end

end
