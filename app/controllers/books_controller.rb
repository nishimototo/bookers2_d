class BooksController < ApplicationController
  before_action :ensure_correct_user, only: [:edit, :update]
  impressionist :actions=> [:show]

  def index
    @user = current_user
    @book = Book.new
    @books = Book.all.order(params[:sort])
  end

  def show
    @book = Book.find(params[:id])
    @user = @book.user
    @newbook = Book.new
    @book_comment = BookComment.new
    impressionist(@book, nil, unique: [:ip_address])
  end

  def edit

  end

  def update
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render :edit
    end
  end

  def create
    @book = current_user.books.new(book_params)
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @user = current_user
      @books = Book.all
      render :index
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private
    def book_params
      params.require(:book).permit(:title, :body, :rate)
    end

    def ensure_correct_user
      @book = Book.find(params[:id])
      if @book.user != current_user
        redirect_to books_path
      end
    end
end
