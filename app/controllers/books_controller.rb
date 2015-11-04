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

    @copies.each do |c|
      if current_user.book_copy_users.where(book_copy_id: c.id).first
        @user_have_book = true
      end
    end
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
    @genres = @book.genres
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

    if !BookCopy.where(isbn: @copy.isbn).first
      @copy.save!
      redirect_to user_path(current_user)
    else
      book_create_copy_path(params[:book_id])
    end
  end

  def generate_isbn
    @a = (0...3).map {(65 + rand(26)).chr}.join
    @b = rand(10 ** 3).to_s.rjust(3)
    @c = (0...3).map {(65 + rand(26)).chr}.join
    @isbn = [@a,@b,@c].join('-')
  end


  def add_genre
    @book = Book.find(params[:book_id])
    @genre = Genre.find(params[:genre_id])

    @new_group_subject = @book.book_genres.create(genre_id: @genre.id)
  end

  def remove_genre
    @book = Book.find(params[:book_id])
    @genre = Genre.find(params[:genre_id])

    BookGenre.where(genre_id: @genre.id, book_id: @book.id).first.destroy
  end



  private

  def book_params
    params.require(:book).permit(:title, :year, :user_id, :author_id, :language_id, :cover)
  end

end
