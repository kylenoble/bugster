class RequestsController < ApplicationController
  before_action :check_login
  before_action :set_request, only: [:show, :edit, :update, :destroy]
  before_action :get_asana_info
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
        @requests = Request.search(params[:search_term]).records.page(params[:page])
      else
        @requests = Request.search(params[:search_term]).records.where("org = ?", @user.org).page(params[:page])
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
    @request.user_id = @user.id
    @request.org = @user.org
    task_id = Asana.create_task(@workspace, @project, request_params[:title])
    @request.task_id = task_id
    Asana.create_comment(task_id, create_detailed_comment)
    if @request.save
      if params[:request][:images]
        params[:request][:images].each { |image|
          @request.images.create(image: image)
          Asana.create_attachment(task_id, image)
        }
      end
    end
    RequestCreator.delay.send_request_notifier_email(@request)
    respond_with(@request)
  end

  def update
    @request.update(request_params)
    respond_with(@request)
  end

  def destroy
    @request.destroy
    respond_with(@request)
  end

  private

    def get_asana_info
      @workspace = 11578168261560
      @project = 26598858855779
    end

    def create_detailed_comment
      return "Org- #{request_params[:org]}" + " Reporter- #{request_params[:requestor]} --> " + request_params[:details] 
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
