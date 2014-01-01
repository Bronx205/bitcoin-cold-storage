class SessionsController < ApplicationController

	def new
		@title=full_title(setup_title)
	end
	
	def create
		@title=full_title(setup_title)
		@howmany=params[:howmany]
		redirect_to private_path
	end

end
