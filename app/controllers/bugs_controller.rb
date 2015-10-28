class BugsController < ApplicationController
  before_action :set_bug, only: [:show, :edit, :update, :destroy]
  before_action :check_login, except: [:show, :new]
  respond_to :html

  def index
    if params[:search_term].nil?
      if admin_signed_in?
        if params[:status] == "completed"
          @bugs = Bug.completed.order(:created_at).page(params[:page])
        elsif params[:status] == "open"
          @bugs = Bug.open.order(:created_at).page(params[:page])
        elsif params[:status] == "monitoring"
          @bugs = Bug.monitoring.order(:created_at).page(params[:page])
        else
          @bugs = Bug.order(:created_at).page(params[:page])
        end
      else
        if params[:status] == "completed"
          @bugs = Bug.completed.where("org = ?", @user.org).order(:created_at).page(params[:page])
        elsif params[:status] == "open"
          @bugs = Bug.open.where("org = ?", @user.org).order(:created_at).page(params[:page])
        elsif params[:status] == "monitoring"
          @bugs = Bug.monitoring.where("org = ?", @user.org).order(:created_at).page(params[:page])
        else
          @bugs = Bug.where("org = ?", @user.org).order(:created_at).page(params[:page])
        end
      end
    else
      if admin_signed_in?
        if params[:status] == "completed"
          @bugs = Bug.search(params[:search_term]).records.completed.order(:created_at).page(params[:page])
        elsif params[:status] == "open"
          @bugs = Bug.search(params[:search_term]).records.where("status != ?", ["Completed"]).order(:created_at).page(params[:page])
        elsif params[:status] == "monitoring"
          @bugs = Bug.search(params[:search_term]).records.where("status = ?", ["Monitoring"]).order(:created_at).page(params[:page])
        else
          @bugs = Bug.search(params[:search_term]).records.order(:created_at).page(params[:page])
        end
      else
        if params[:status] == "completed"
          @bugs = Bug.where("org = ?", @user.org).search(params[:search_term]).records.completed.order(:created_at).page(params[:page])
        elsif params[:status] == "open"
          @bugs = Bug.where("org = ?", @user.org).search(params[:search_term]).records.where("status != ?", ["Completed"]).order(:created_at).page(1)
        elsif params[:status] == "monitoring"
          @bugs = Bug.where("org = ?", @user.org).search(params[:search_term]).records.where("status != ?", ["Monitoring"]).order(:created_at).page(1)
        else
          @bugs = Bug.where("org = ?", @user.org).search(params[:search_term]).records.order(:created_at).page(params[:page])
        end
      end
    end
    respond_with(@bug)
  end

  def show
    @comments = @bug.comments.all.order("created_at asc")
    @comment = @bug.comments.build
  end

  def new
    @bug = Bug.new
    respond_with(@bug)
  end

  def edit
  end

  def create
    @bug = Bug.new(bug_params)
    get_asana_info
    task_id = Asana.create_task(@workspace, @project, bug_params[:title])
    @bug.task_id = task_id
    outage_reported(@bug)
    if @bug.save
      if params[:bug][:images]
        params[:bug][:images].each { |image|
          @bug.images.create(image: image)
        }
      end
    end
    Asana.delay.create_comment(@bug.task_id, create_detailed_comment)
    BugCreator.delay.send_bug_notifier_email(@bug)
    
    if params[:bug][:org].to_i != 0
      redirect_to("/decision7/tickets/#{@bug.id}")
    else
      redirect_to("/ignitetek/tickets/#{@bug.id}")
    end
  end

  def update
    if @bug.update(bug_params)   
      if request.fullpath[1..9].downcase == "decision7"
        redirect_to("/decision7/tickets/#{@bug.id}")
      else
        redirect_to("/ignitetek/tickets/#{@bug.id}")
      end
    else
      if request.fullpath[1..9].downcase == "decision7"
        redirect_to("/decision7/tickets/#{@bug.id}/edit")
      else
        redirect_to("/ignitetek/tickets/#{@bug.id}/edit")
      end
    end
  end

  def destroy
    @bug.destroy
    if request.fullpath[1..9].downcase == "decision7"
      redirect_to("/decision7/tickets")
    else
      redirect_to("/ignitetek/tickets")
    end
  end

  private

    def check_login
      if user_signed_in? || admin_signed_in?
        @user = current_user
      else 
        redirect_to :login
      end
    end

    def outage_reported(bug)
      if bug.priority == "Outage"
        @bug.email += ", knoble@ignitemedia.com, hdobariya@ignitemedia.com, sandy@ignitemedia.com"
      end
    end

    def create_detailed_comment
      return "Org- #{@bug.org}" + " Reporter- #{@bug.reporter} --> " + @bug.details
    end

    def get_asana_info
      if params[:bug][:org].to_i != 0
        @workspace = 11578168261560
        @project = 26598858855777
      else
        @workspace = 11578168261560
        @project = 30404475020681
      end
    end

    def set_bug
      @bug = Bug.find(params[:id])
    end

    def bug_params
      params.require(:bug).permit(:title, :details, :priority, :reporter, :bugster, :email, :org, :task_id, :status, :category, :push_date, :search_term, images: [:image])
    end
end
