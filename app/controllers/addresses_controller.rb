class AddressesController < ApplicationController
	require 'rqrcode'
	include AddressesHelper
  
	def new
		@title=full_title(setup_title)
		@howmany=cookies[:howmany] 
		@howmany=1 if @howmany.blank? 
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
  
  def private
  	@title=private_title
		@howmany=cookies[:howmany].to_i
		@howmany||=1
		redirect_to root_path unless @howmany > 0
		@addresses=generate_addresses_array(@howmany)
		@download=params[:download]				
		send_data(render_to_string, :filename => "coldstorage.html") if @download

  end

  def public
  	@title=public_title
		@howmany=cookies[:howmany].to_i
		@howmany||=1
		redirect_to root_path unless @howmany > 0
		@addresses=generate_addresses_array(@howmany)
		@download=params[:download]				
		send_data(render_to_string, :filename => "coldstorage.html") if @download  	
  end
end
