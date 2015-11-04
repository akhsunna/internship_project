class BookCopiesController < ApplicationController

  def delete
    @book_copy = BookCopy.find(params[:book_copy_id])
    @book = @book_copy.book
  end

  def destroy
    @book_copies = BookCopy.all
    @book_copy = BookCopy.find(params[:id])
    @book = @book_copy.book
    @book_copy.destroy
  end



  def take
    @book_copy = BookCopy.find(params[:book_copy_id])
    @user = current_user

    @new_group_subject = @user.book_copy_users.create(book_copy_id: @book_copy.id)
  end

  def return
    @book_copy = BookCopy.find(params[:book_copy_id])
    @user = current_user

    BookCopyUser.where(book_copy_id: @book_copy.id, user_id: @user.id).first.destroy
  end

end
