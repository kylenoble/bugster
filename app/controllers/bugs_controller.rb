class BugsController < ApplicationController
  before_action :set_bug, only: [:show, :edit, :update, :destroy]

  respond_to :html

  def index
    @bugs = Bug.order(:created_at).page params[:page]
    respond_with(@bugs)
  end

  def show
    @comments = @bug.comments.all
    @comment = @bug.comments.build
    respond_with(@bug)
  end

  def new
    @bug = Bug.new
    respond_with(@bug)
  end

  def edit
  end

  def create
    @bug = Bug.new(bug_params)
    if @bug.save
      BugCreator.send_bug_notifier_email(@bug).deliver
      if params[:bug][:images]
        logger.debug "True"
        params[:bug][:images].each { |image|
          @bug.images.create(image: image)
        }
      end
    end
    respond_with(@bug)
  end

  def update
    @bug.update(bug_params)
    respond_with(@bug)
  end

  def destroy
    @bug.destroy
    respond_with(@bug)
  end

  private
    def set_bug
      @bug = Bug.find(params[:id])
    end

    def bug_params
      params.require(:bug).permit(:title, :details, :bugster, :email, :org, :status, :category, :push_date, images: [:image])
    end
end
