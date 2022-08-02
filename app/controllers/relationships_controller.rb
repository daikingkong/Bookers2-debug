class RelationshipsController < ApplicationController
  # フォローするとき
  # followed_idと
  # follower_idが必要
  # followed_id(する人)は必ずログインしてる人、つまりカレントユーザー自身のid
  # foollwer_id(される人)は、自分がフォロー使用としている相手のid
  def create
    current_user.follow(params[:user_id])
    redirect_to request.referer
  end
  # フォロー外すとき
  def destroy
    current_user.unfollow(params[:user_id])
    redirect_to request.referer
  end
   # フォロー一覧
  def followings
    user = User.find(params[:user_id])
    @users = user.followings
  end
   # フォロワー一覧
  def followers
    user = User.find(params[:user_id])
    @users = user.followers
  end
end
