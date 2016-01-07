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
      @request = Trello::Card.find(@comment.request.task_id)
      @request.add_comment(create_detailed_comment)
      RequestCommentCreator.delay.send_request_comment_notifier_email(@comment)
    else
      @bug = Trello::Card.find(@comment.bug.task_id)
      @bug.add_comment(create_detailed_comment)
      CommentCreator.delay.send_comment_notifier_email(@comment)
    end

    if !@comment.request_id && Bug.find(params[:comment][:bug_id]).org.to_i != 0
      redirect_to("/decision7/tickets/#{@comment.bug_id}")
    elsif !@comment.bug_id && Request.find(@comment.request_id).org.to_i != 0
      redirect_to("/decision7/tickets/#{@comment.request_id}")
    elsif !@comment.request_id && Bug.find(@comment.bug_id).org.to_i == 0
      redirect_to("/ignitetek/tickets/#{@comment.bug_id}")
    else
      redirect_to("/ignitetek/tickets/#{@comment.request_id}")
    end
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
      return "Comment Body- #{@comment.body}"
    end

    def set_comment
      @comment = Comment.find(params[:id])
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
