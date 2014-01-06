class AddressesController < ApplicationController
	require 'rqrcode'
	include AddressesHelper

  def new
		@title=full_title(setup_title)
		set_amount howmany
	end
	
	def create
		@title=full_title(setup_title)
		set_amount params[:howmany]
		if params[:howmany].to_i > 0
			set_addresses_array			
			redirect_to private_path 
		else
			render 'new'
		end
	end
  
  def private
  	@title=private_title
		redirect_to root_path unless howmany > 0
		@addresses=addresses_array
		@download=params[:download]				
		send_data(render_to_string, :filename => "coldstorage.html") if @download

  end

  def public
  	@title=public_title

  end
end
