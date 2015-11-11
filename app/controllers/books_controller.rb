# Controller for books
class BooksController < ApplicationController
  respond_to :html, :js, :json

  def index
    @books = Book.all.order('updated_at DESC')
    @authors = Author.all.sort_by(&:readers).reverse!.first(8)
    @languages = Language.all
    @genres = Genre.where(id: params[:genre_ids])

    @genre_ids = params[:genre_ids].collect(&:to_i) if params[:genre_ids]
    @books = Book.genres(Genre.find(@genre_ids)) if @genre_ids

    @books = @books.title_like params[:title] if params[:title]

    @books = @books.by_author params[:author] if params[:author]
  end

  def show
    @book = Book.find(params[:id])
    @copies = BookCopy.where(book_id: @book.id)
    @comment = Comment.new
    mycopy = current_user.have_book?(@book)
    return unless mycopy
    @user_have_book = true
    @mybook = mycopy.book_copy.isbn
    bcu = BookCopyUser.where(book_copy_id: mycopy.book_copy.id).last
    @days = (Date.today - bcu.last_date).to_i
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
    copy = BookCopy.new
    copy.user_id = current_user.id
    copy.available = true
    copy.book_id = params[:book_id]
    copy.save!
    redirect_to user_path(current_user)
  end

  def add_remove_genre
    @book = Book.find(params[:book_id])
    @genre = Genre.find(params[:genre_id])

    @book_genre = BookGenre.where(genre_id: @genre.id, book_id: @book.id).first

    if @book_genre
      @book_genre.destroy
    else
      @new_book_genre = @book.book_genres.create(genre_id: @genre.id)
    end
  end

  private

  def book_params
    params.require(:book).permit(:title, :year, :user_id,
                                 :author_id, :language_id, :cover)
  end
end
