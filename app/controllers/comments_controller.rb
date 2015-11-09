# Controller for comments
class CommentsController < ApplicationController
  before_filter :get_parent

  def new
    @comment = @parent.comments.build
  end

  def create
    @comment = @parent.comments.build(comment_params)

    if @comment.save
      redirect_to @parent
    else
      render :new
    end
  end

  def destroy
    @comment = @parent.comments.find(params[:id])
    if @comment.destroy
      flash[:notice] = 'Comment was removed'
      redirect_to @parent
    else
      flash[:notice] = 'There was an error removing comment'
    end
  end

  protected

  def get_parent
    @parent = Book.find_by_id(params[:book_id]) if params[:book_id]
    @parent = Author.find_by_id(params[:author_id]) if params[:author_id]

    redirect_to root_path unless defined?(@parent)
  end

  private

  def comment_params
    params.require(:comment).permit(:user_id, :body)
  end
end
