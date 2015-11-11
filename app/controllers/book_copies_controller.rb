# Controller for book copies
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
    @book_copy = Book.find(params[:book_copy_id]).first_available_copy
    @user = current_user

    change_available @book_copy

    @bookcopyuser = @user.book_copy_users.create(book_copy_id: @book_copy.id,
                                                 last_date: Date.today + 7)

    UserMailer.delay(run_at: 7.days.from_now).reminder_email(@user, @book)
    @bookcopyuser.job_id = Delayed::Job.last.id
    @bookcopyuser.save!

    respond_to { |format| format.js { render inline: 'location.reload();' } }
  end

  def return
    @user = current_user
    @book_copy_user = current_user.have_book?(Book.find(params[:book_copy_id]))

    change_available @book_copy_user.book_copy

    @book_copy_user.return_date = Time.now
    @book_copy_user.save!

    if @book_copy_user.return_date < @book_copy_user.last_date
      job = Delayed::Job.find(@book_copy_user.job_id)
      job.delete
    end

    respond_to { |format| format.js { render inline: 'location.reload();' } }
  end

  def change_available(book_copy)
    book_copy.available = !book_copy.available
    book_copy.save!
  end
end
