class CommentsController < ApplicationController
  before_action :set_comment, only: [:show, :edit, :update, :destroy]
  respond_to :html

  def index
    @comments = Comment.all
  end

  def show
    respond_type
  end

  def new
    @comment = Comment.new
    respond_type
  end

  def edit
  end

  def create
    @comment = Comment.new(comment_params)

    @comment.story_id = @story_id
    if @comment.save
      if params[:comment][:images]
        params[:comment][:images].each { |image|
          @comment.images.create(image: image)
        }
      end
    end

    if !@comment.bug_id
      Asana.delay.create_comment(@comment.request.task_id, create_detailed_comment)
      RequestCommentCreator.delay.send_request_comment_notifier_email(@comment)
    else 
      Asana.delay.create_comment(@comment.bug.task_id, create_detailed_comment)
      CommentCreator.delay.send_comment_notifier_email(@comment)
    end
    respond_type
  end

  def update
    @comment.update(comment_params)
    respond_type
  end

  def destroy
    @comment.destroy
    respond_type
  end

  private

    def create_detailed_comment
      return "Body- #{@comment.body}"
    end

    def set_comment
      @comment = Comment.find(params[:id]).includes(images: [:image])
    end

    def respond_type
      if !@comment.bug_id
        redirect_to(@comment.request)
      else 
        redirect_to(@comment.bug)
      end
    end

    def comment_params
      params.require(:comment).permit(:user_name, :body, :bug_id, :request_id, images: [:image])
    end
end
