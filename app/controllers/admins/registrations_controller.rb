class Admins::RegistrationsController < Devise::RegistrationsController
# before_filter :configure_sign_up_params, only: [:create]
# before_filter :configure_account_update_params, only: [:update]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  def create
    if admin_params[:admin_secret] == ENV["ADMIN_SECRET"]
      @admin = Admin.create(admin_params)
      @admin.valid?
      if @admin.save! && admin_params[:admin_secret] == ENV["ADMIN_SECRET"]
        sign_in(@admin)
        redirect_to "/"
      else
        flash[:alert] = "Error occurred. Please try again."
        redirect_to "/admins/sign_up"
      end
    else
      flash[:alert] = "Admin secret incorrect. Please try again."
      redirect_to "/admins/sign_up"
    end
  end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

    def admin_params
      params.require(:admin).permit(:email, :password, :password_confirmation, :remember_me, :name, :admin_secret)
    end

  # You can put the params you want to permit in the empty array.
  # def configure_account_update_params
  #   devise_parameter_sanitizer.for(:account_update) << :attribute
  # end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end
end
