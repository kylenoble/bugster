class CommentsController < ApplicationController
  before_action :set_comment, only: [:show, :edit, :update, :destroy]
  respond_to :html

  def index
    @comments = Comment.all
    redirect_to(@comment.bug)
  end

  def show
    redirect_to(@comment.bug)
  end

  def new
    @comment = Comment.new
    redirect_to(@comment.bug)
  end

  def edit
  end

  def create
    @comment = Comment.new(comment_params)
    @comment.save
    redirect_to(@comment.bug)
  end

  def update
    @comment.update(comment_params)
    redirect_to(@comment.bug)
  end

  def destroy
    @comment.destroy
    redirect_to(@comment.bug)
  end

  private
    def set_comment
      @comment = Comment.find(params[:id])
    end


    def comment_params
      params.require(:comment).permit(:user_name, :body, :bug_id)
    end
end
