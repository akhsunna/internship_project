class AuthorsController < ApplicationController

  def index
    @authors = Author.all
  end

  def new
    @author = Author.new
  end

  def create
    @author = Author.new(author_params)
    if @author.save
      redirect_to root_path, notice: 'The book has been successfully created.'
    else
      render action: 'new'
    end
  end

  private

  def author_params
    params.require(:author).permit(:first_name, :last_name)
  end

end
