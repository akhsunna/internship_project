class BooksController < ApplicationController

  respond_to :html, :js

  def index
    @books = Book.all
    @authors = Author.all
    @languages = Language.all
  end

  def show
    @book = Book.find(params[:id])
    @copies = @book.book_copies
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

  def delete
    @book = Book.find(params[:book_id])
  end

  def destroy
    @books = Book.all
    @book = Book.find(params[:id])
    @book.destroy
  end

  def update
    @books = Book.all
    @book = Book.find(params[:id])
    @book.update_attributes(book_params)
    # redirect_to user_path(current_user.id)
  end

  def genres
    @book = Book.find(params[:book_id])
    @genres = Genre.all
  end

  def copies
    @book = Book.find(params[:book_id])
    @copies = BookCopy.where(book_id: @book.id)
  end


  def create_copy
    @copy = BookCopy.new()
    @copy.isbn = generate_isbn
    @copy.user_id = current_user.id
    @copy.available = true
    @copy.book_id = params[:book_id]
    @copy.save!
    redirect_to user_path(current_user)
  end

  def generate_isbn
    @a = (0...3).map {(65 + rand(26)).chr}.join
    @b = rand(10 ** 3).to_s.rjust(3)
    @c = (0...3).map {(65 + rand(26)).chr}.join
    @isbn = [@a,@b,@c].join('-')

    # if BookCopy.all.exists?(isbn: @isbn)
    #   generate_isbn
    # end
  end



  private

  def book_params
    params.require(:book).permit(:title, :year, :user_id, :author_id, :language_id, :cover)
  end

end
