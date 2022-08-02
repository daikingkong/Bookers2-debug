class SearchesController < ApplicationController
  before_action :authenticate_user!

  def search
    # paramsフォームやURLなどによって送られてきた情報
    # （パラメーター）を取得するメソッドです。
    # その後に、@modelの値がuserだった場合と、bookだった場合で条件分岐しています。
    @model = params[:model]
    @content = params[:content]
    @method = params[:method]
    if @model == 'user'
      @records = User.search_for(@content, @method)
    else
      @records = Book.search_for(@content, @method)
      # @recordsに入れているのは検索結果
    end
  end
end
