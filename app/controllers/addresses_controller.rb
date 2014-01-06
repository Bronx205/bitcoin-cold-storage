class AddressesController < ApplicationController
	require 'rqrcode'
	include AddressesHelper
	include CryptoHelper

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
		encrypted_page=encrypt_my_page(render_to_string)				
		unencrypted_page=render_to_string
		send_data(unencrypted_page, :filename => "colds.html") if @download=='plain'
		send_data(encrypted_page, :filename => "cold.html.aes") if @download=='encrypted'
  end

  def public
  	@title=public_title

  end
end
