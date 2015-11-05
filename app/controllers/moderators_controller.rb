class ModeratorsController < ApplicationController

  def show
    @user = User.find(params[:id])
    @books = @user.books.order('updated_at DESC')

    @copy = BookCopy.new
  end

end
