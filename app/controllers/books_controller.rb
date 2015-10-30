class BooksController < ApplicationController

  def index
    @books = Book.all
  end

  def show
    @book = Book.find(params[:id])
  end

  def new
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    if @book.save
      redirect_to books_path, notice: 'The book has been successfully created.'
    else
      render action: 'new'
    end
  end


  def edit
    @book = Book.find(params[:id])
  end

  def update
    @books = Book.all
    @book = Book.find(params[:id])
    @book.update_attributes(book_params)
    redirect_to user_path(current_user.id)
  end

  private

  def book_params
    params.require(:book).permit(:title, :year, :user_id, :author_id, :language_id, :cover)
  end

end
