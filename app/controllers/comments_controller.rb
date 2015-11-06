class CommentsController < ApplicationController

  before_filter :get_parent

  def new
    @comment = @parent.comments.build
  end

  def create
    @comment = @parent.comments.build(params[:comment])

    if @comment.save
      respond_to do |format|
        format.js {render inline: 'location.reload();' }
      end
    else
      render :new
    end
  end

  protected

  def get_parent
    @parent = Book.find_by_id(params[:book_id]) if params[:book_id]

    redirect_to root_path unless defined?(@parent)
  end

end
