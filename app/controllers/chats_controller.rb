class ChatsController < ApplicationController
  before_action :reject_non_related, only: [:show]

  def show
    @user = User.find(params[:id])
    rooms = current_user.user_rooms.pluck(:room_id)
    # plunk=摘み取り=>今回でいうログインユーザーの
    # user_roomsテーブルからroom_idカラムの値だけを取得して
    # 配列で格納
    user_room = UserRoom.find_by(user_id: @user.id, room_id: rooms)

    unless user_room.nil?
      @room = user_room.room
    else
      @room = Room.new
      @room.save
      UserRoom.create(user_id: current_user.id, room_id: @room.id)
      UserRoom.create(user_id: @user.id, room_id: @room.id)
      # create()は、newとsave
      # (新しい空の入れ物の準備と保存）を同時にできるやつ
      # ユーザーIDという名の箱の中に現在のユーザーのID（もしくは相手の）を入れて
      # ルームIDという箱の中に二人の共通のルームIDをいれて保存。
      # これで新しいチャットルームが完成するんですね。
    end
    @chats = @room.chats
    @chat = Chat.new(room_id: @room.id)
  end

  def create
    @chat = current_user.chats.new(chat_params)
    render :validater unless @chat.save
  end

  private

  def chat_params
    params.require(:chat).permit(:message, :room_id)
  end

  def reject_non_related
    user = User.find(params[:id])
    unless current_user.following?(user) && user.following?(current_user)
      # でなければtrue、ログインユーザーがbefore_action onlyのshowのユーザーをフォローしているなおかつ逆にフォローされているかどうか
      redirect_to books_path
      # trueだった場合の処理にリダイレクトで投稿一覧へ
    end
  end
  # shatしようchat詳細画面へ行こうとしたときに、相互フォロー状態なら
end
