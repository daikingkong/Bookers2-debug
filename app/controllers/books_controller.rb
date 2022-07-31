class BooksController < ApplicationController
  before_action :authenticate_user!
  before_action :ensure_correct_user, only: [:edit, :update, :destroy]
  # before_action :ensure_correct_user, only: [:edit, :update]　destroyも他のユーザーにされないように

  # def show
  #   @book_new = Book.new
  #   @book = Book.find(params[:id])
  #   @user = @book.user
  #   @book_comment_new = BookComment.new
  #   @comments = @book.book_comments
  # end

  def show
    @book_new = Book.new
    @book = Book.find(params[:id])
    @book_comment = BookComment.new
    @user = @book.user
  end


  def index
    @book = Book.new
    @books = Book.all
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def edit
    @book = Book.find(params[:id])
    # ネストしてるから上の記述無くても良い
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    # ネストしてるから上の記述無くても良い
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body,)
  end

  def ensure_correct_user
    @book = Book.find(params[:id])
    unless @book.user == current_user
      redirect_to books_path
    end
  end

  # def ensure_correct_user
  #   @book = Book.find(params[:id])
  #   @user = @book.user
  #   unless @user == current_user　@book.user == current_userで一行で済む
  #     redirect_to books_path
  #   end
  # end
end
