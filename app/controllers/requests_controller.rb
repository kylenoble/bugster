class RequestsController < ApplicationController
  before_action :check_login
  before_action :set_request, only: [:show, :edit, :update, :destroy]
  respond_to :html

  def index
    if params[:search_term].nil?
      if admin_signed_in?
        if params[:status] == "completed"
          @requests = Request.completed.order(:created_at).page(params[:page])
        elsif params[:status] == "open"
          @requests = Request.open.order(:created_at).page(params[:page])
        else
          @requests = Request.order(:created_at).page(params[:page])
        end
      else
        if params[:status] == "completed"
          @requests = Request.completed.where("org = ?", @user.org).order(:created_at).page(params[:page])
        elsif params[:status] == "open"
          @requests = Request.open.where("org = ?", @user.org).order(:created_at).page(params[:page])
        else
          @requests = Request.where("org = ?", @user.org).order(:created_at).page(params[:page])
        end
      end
    else
      if admin_signed_in?
        if params[:status] == "completed"
          @requests = Request.completed.order(:created_at).search(params[:search_term]).records.page(params[:page])
        elsif params[:status] == "open"
          @requests = Request.search(params[:search_term]).records.where("status != ?", ["Completed"]).order(:created_at).page(params[:page])
        else
          @requests = Request.search(params[:search_term]).records.order(:created_at).page(params[:page])
        end
      else
        if params[:status] == "completed"
          @requests = Request.completed.where("org = ?", @user.org).search(params[:search_term]).records.page(params[:page])
        elsif params[:status] == "open"
          @requests = Request.where("org = ?", @user.org).search(params[:search_term]).records.where("status != ?", ["Completed"]).page(params[:page])
        else
          @requests = Request.where("org = ?", @user.org).search(params[:search_term]).records.order(:created_at).page(params[:page])
        end
      end
    end
    respond_with(@bug)
  end

  def show
    @comments = @request.comments.all
    @comment = @request.comments.build
    respond_with(@request)
  end

  def new
    @request = Request.new
    respond_with(@request)
  end

  def edit
  end

  def create
    @request = Request.new(request_params)
    if user_signed_in?
      @request.user_id = @user.id
      @request.org = @user.org
    else 
      @request.user_id = current_admin.id
    end
    get_asana_info
    task_id = Asana.create_task(@workspace, @project, request_params[:title])
    @request.task_id = task_id
    if @request.save
      if params[:request][:images]
        params[:request][:images].each { |image|
          @request.images.create(image: image)
        }
      end
    end
    Asana.delay.create_comment(@request.task_id, create_detailed_comment)
    RequestCreator.delay.send_request_notifier_email(@request)

    if params[:request][:org].to_i != 0
      redirect_to("/decision7/requests/#{@request.id}")
    else
      redirect_to("/ignitetek/requests/#{@request.id}")
    end
  end

  def update
    if @request.update(request_params)   
      if request.fullpath[1..9].downcase == "decision7"
        redirect_to("/decision7/requests/#{@request.id}")
      else
        redirect_to("/ignitetek/requests/#{@request.id}")
      end
    else
      if request.fullpath[1..9].downcase == "decision7"
        redirect_to("/decision7/requests/#{@request.id}/edit")
      else
        redirect_to("/ignitetek/requests/#{@request.id}/edit")
      end
    end
  end

  def destroy
    @request.destroy
    if request.fullpath[1..9].downcase == "decision7"
      redirect_to("/decision7/requests")
    else
      redirect_to("/ignitetek/requests")
    end
  end

  private

    def get_asana_info
      if request.fullpath[1..9].downcase == "decision7"
        @workspace = 11578168261560
        @project = 26598858855779
      else
        @workspace = 11578168261560
        @project = 30404475020683
      end
    end

    def create_detailed_comment
      image_urls = ""
      @request.images.each { |image|
        image_urls += "#{image.image.url(:lrg)}, "
      }
      return "Org- #{@request.org}" + " Requestor- #{@request.requestor} --> " + @request.details
    end

    def check_login
      if user_signed_in? || admin_signed_in?
        @user = current_user
      else 
        redirect_to :login
      end
    end

    def set_request
      @request = Request.find(params[:id])
    end

    def request_params
      params.require(:request).permit(:title, :details, :email, :priority, :requestor, :user_id, :org, :status, :category, :push_date, :search_term , images: [:image])
    end
end
