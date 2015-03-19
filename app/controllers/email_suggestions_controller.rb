class EmailSuggestionsController < ApplicationController
	def index
		if user_signed_in?
    	render json: EmailSuggestion.terms_for_user(params[:term], current_user.org)
    end
    elsif admin_signed_in?
    	render json: EmailSuggestion.terms_for_admin(params[:term], current_user.org)
    end
  end

  private

    def email_suggestions_params
      params.require(:comment).permit(:term)
    end
end