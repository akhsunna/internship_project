class BooksController < ApplicationController

  respond_to :html, :js

  def index
    @books = Book.all.order('updated_at DESC')
    @authors = Author.all
    @languages = Language.all
  end

  def show
    @book = Book.find(params[:id])
    @copies = @book.book_copies

    @copies.each do |c|
      if !c.available
        if c.book_copy_users.where(user_id: current_user.id, return_date: nil).last
          @user_have_book = true
          @mybook = c.isbn
          @days = (Date.today - BookCopyUser.where(book_copy_id: c.id).last.last_date ).to_i
          return
        end
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

    @new_book_copy_user = @user.book_copy_users.create(book_copy_id: @book_copy.id)
    respond_to do |format|
      format.js {render inline: 'location.reload();' }
    end
  end

  def return
    @book = Book.find(params[:book_id])
    @book_copy = BookCopy.where(book_id: @book.id).first
    @user = current_user

    @book_copy.available = true
    @book_copy.save!

    @book_copy_user = BookCopyUser.where(book_copy_id: @book_copy.id, user_id: @user.id).last
    @book_copy_user.return_date = Time.now
    @book_copy_user.save!

    respond_to do |format|
      format.js {render inline: 'location.reload();' }
    end
  end



  private

  def book_params
    params.require(:book).permit(:title, :year, :user_id, :author_id, :language_id, :cover)
  end

end
