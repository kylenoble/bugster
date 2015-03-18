class EmailSuggestionsController < ApplicationController
	def index
		if admin_signed_in?
			puts "terms: #{EmailSuggestion.terms_for(params[:term], current_admin.org)}"
    	render json: EmailSuggestion.terms_for(params[:term], current_admin.org)
    else
    	puts "terms: #{EmailSuggestion.terms_for(params[:term], current_user.org)}"
    	render json: EmailSuggestion.terms_for(params[:term], current_user.org)
    end
  end

  private

    def email_suggestions_params
      params.require(:comment).permit(:term)
    end
end