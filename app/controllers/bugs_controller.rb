class BugsController < ApplicationController
  before_action :set_bug, only: [:show, :edit, :update, :destroy]
  before_action :get_asana_info
  respond_to :html

  def index
    @bugs = Bug.order(:created_at).page params[:page]
    respond_with(@bugs)
  end

  def show
    update_comments
    @comments = @bug.comments.all.order("created_at asc")
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
    task_id = Asana.create_task(@workspace, @project, bug_params[:title])
    @bug.task_id = task_id
    Asana.create_comment(task_id, bug_params[:details])
    if @bug.save
      if params[:bug][:images]
        params[:bug][:images].each { |image|
          @bug.images.create(image: image)
          Asana.create_attachment(task_id, image)
        }
      end
    end
    #BugCreator.send_bug_notifier_email(@bug)
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

    def update_comments
        asana_comments = Asana.get_comments(@bug.task_id)
        if !asana_comments.nil?
          asana_comments["data"].each do |comment|
            if comment["type"] == "comment" && Comment.where("story_id = ? ", comment["id"].to_s).empty? && comment["text"] != @bug.details
              Comment.create!(:created_at => comment["created_at"], :body => comment["text"], 
                :user_name => comment["created_by"]["name"], :bug_id => @bug.id, 
                :story_id => comment["id"].to_s)
            end
          end
        end
    end

    def get_asana_info
      @workspace = 11578168261560
      @project = 26598858855777
    end

    def set_bug
      @bug = Bug.find(params[:id])
    end

    def bug_params
      params.require(:bug).permit(:title, :details, :bugster, :email, :org, :status, :category, :push_date, images: [:image])
    end
end
