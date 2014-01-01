class SessionsController < ApplicationController

	def new
		@title=full_title(setup_title)
		@howmany=cookies[:howmany] 
	end
	
	def create
		@title=full_title(setup_title)
		@howmany=params[:howmany]
		cookies[:howmany]=@howmany
		if @howmany.to_i > 0
			redirect_to private_path 
		else
			render 'new'
		end
	end

end
