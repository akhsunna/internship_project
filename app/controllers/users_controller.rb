# Controller for users
class UsersController < ApplicationController
  def show
    redirect_to moderator_path(current_user) if current_user.moderator?
    @user = User.find(params[:id])
    @bookcopies = BookCopyUser.where(user_id: current_user.id)
    @bookcopiesnow = @bookcopies.where(return_date: nil)
    @bookcopiesnotnow = @bookcopies.where.not(return_date: nil)
  end

  def index
    @book_copies = BookCopy.where(available: false, user_id: current_user.id)
    @book_copies = @book_copies.reject do |bc|
      BookCopyUser.where(book_copy_id: bc.id).last.last_date > Time.now
    end
  end

  def finish_signup
    return unless request.patch? && params[:user] && params[:user][:email]
    if @user.update(user_params)
      @user.skip_reconfirmation!
      sign_in(@user, bypass: true)
      redirect_to user_path(current_user)
    else
      @show_errors = true
    end
  end

  private

  def user_params
    accessible = [:name, :email]
    unless params[:user][:password].blank?
      accessible << [:password, :password_confirmation]
    end
    params.require(:user).permit(accessible)
  end
end
