# Controller for books
class BooksController < ApplicationController
  respond_to :html, :js, :json

  def index
    @books = Book.all.order('updated_at DESC')
    @authors = Author.all.reverse_each(&:readers).first(8)
    @languages = Language.all
    @genres = Genre.all

    genre_ids = params[:genre_ids].collect(&:to_i) if params[:genre_ids]
    if genre_ids
      @genres = Genre.find(genre_ids)
      @books = Book.genres(@genres)
    end

    if params[:author]
      @filter_author = Author.where('last_name = ? OR first_name = ?', params[:author], params[:author])
      author_ids = @filter_author.map(&:id)
      @books = Book.where('author_id IN (?)', author_ids)
    end

    if params[:title]
      @books = Book.title_like("%#{params[:title]}%").order('title')
    end
  end


  def show
    @book = Book.find(params[:id])
    @copies = BookCopy.where(book_id: @book.id)
    @comment = Comment.new
    mycopy = current_user.have_book?(@book)
    return unless mycopy
    @user_have_book = true
    @mybook = mycopy.book_copy.isbn
    @days = (Date.today - BookCopyUser.where(book_copy_id: mycopy.book_copy.id).last.last_date).to_i
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

  def take
    @book = Book.find(params[:book_id])
    @book_copy = BookCopy.where(book_id: @book.id, available: true).first
    @user = current_user

    @book_copy.available = false
    @book_copy.save!

    @user.book_copy_users.create(book_copy_id: @book_copy.id,
                                 last_date: Date.today + 7)
    respond_to do |format|
      format.js { render inline: 'location.reload();' }
    end
  end

  def return
    @book = Book.find(params[:book_id])
    @user = current_user
    @book_copy_user = current_user.have_book?(@book)

    @book_copy_user.book_copy.available = true
    @book_copy_user.book_copy.save!

    @book_copy_user.return_date = Time.now
    @book_copy_user.save!

    respond_to do |format|
      format.js { render inline: 'location.reload();' }
    end
  end

  private

  def book_params
    params.require(:book).permit(:title, :year, :user_id,
                                 :author_id, :language_id, :cover)
  end
end
