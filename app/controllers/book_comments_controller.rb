class BookCommentsController < ApplicationController
  def create
    @book = Book.find(params[:book_id])
    @comment = current_user.book_comments.new(book_comment_params)
    @comment.book_id = @book.id
    @comment.save
    # referer(リファラ)は
    # 「リンク元のURL（直前に見ていたページのURL）は、これです」
    # な情報が書いてある
    # 結果はしたと同じだが、この記述をすると
    # 処理後にその処理を行う前のページはリダイレクトできる

    # redirect_to book_path(book)
  end

  def destroy
    @book = Book.find(params[:book_id])
    BookComment.find_by(id: params[:id], book_id: params[:book_id]).destroy
  end

  # def destroy
  #   book = Book.find(params[:book_id])
  #   comment = current_user.book_comments.find_by(book_id: @book.id)
  #   comment.destroy
  #   redirect_to request.referer
  # end

  private

  def book_comment_params
    params.require(:book_comment).permit(:comment)
  end
end
