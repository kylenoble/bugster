class RequestsController < ApplicationController
  before_action :check_login
  before_action :set_request, only: [:show, :edit, :update, :destroy]
  before_action :get_asana_info
  respond_to :html

  def index
    if admin_signed_in?
      @requests = Request.order(:created_at).page params[:page]
    else
      @requests = Request.order(:created_at).where("org = ?", @user.org).page params[:page]
    end
    respond_with(@requests)
  end

  def show
    update_comments
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
    @request.email = @user.email
    task_id = Asana.create_task(@workspace, @project, request_params[:title])
    @request.task_id = task_id
    Asana.create_comment(task_id, request_params[:details])
    if @request.save
      if params[:request][:images]
        params[:request][:images].each { |image|
          @request.images.create(image: image)
        }
      end
    end
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

    def update_comments
      asana_comments = Asana.get_comments(@request.task_id)
      if !asana_comments.nil?
        asana_comments["data"].each do |comment|
          if comment["type"] == "comment" && Comment.where("story_id = ? ", comment["id"].to_s).empty? && comment["text"] != @request.details
            Comment.create!(:created_at => comment["created_at"], :body => comment["text"], 
              :user_name => comment["created_by"]["name"], :request_id => @request.id, 
              :story_id => comment["id"].to_s)
          end
        end
      end
    end

    def get_asana_info
      @workspace = 11578168261560
      @project = 26598858855779
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
      params.require(:request).permit(:title, :details, :email, :user_id, :org, :status, :category, :push_date, images: [:image])
    end
end
