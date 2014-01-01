class SessionsController < ApplicationController

	def new
		@title=full_title(setup_title)
		@howmany=cookies[:howmany] 
	end
	
	def create
		@title=full_title(setup_title)
		@howmany=params[:howmany]
		cookies[:howmany]=@howmany
		redirect_to private_path
	end

end
