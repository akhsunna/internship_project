class ModeratorsController < ApplicationController

  def show
    @user = User.find(params[:id])
    @books = @user.books

    @copy = BookCopy.new
  end

end
