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
		Rails.cache.clear
		set_amount params[:howmany]
		set_password strong_password if password.blank?
		if params[:commit] == howmany_button_title && params[:howmany].to_i > 0
			set_addresses_array			
			redirect_to private_path 
		elsif params[:commit] == password_button_title
			set_password params[:password]
			redirect_to root_path
		else
			render 'new'
		end
	end
  
  def private
  	@title=private_title
		redirect_to root_path unless howmany > 0
		@addresses=addresses_array
		@download=params[:download]
		send_data(inject_css(render_to_string), :filename => "colds.html") if @download=='plaintext'
		send_data(encrypt_my_page(inject_css(render_to_string),password), :filename => "cold.html.aes") if @download=='encrypted'
  end

  def public
  	@title=public_title

  end
end
