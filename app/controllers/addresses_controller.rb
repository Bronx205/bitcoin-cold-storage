class AddressesController < ApplicationController
	require 'rqrcode'
	include AddressesHelper
	include CryptoHelper

	# before_filter :clear_cache

  def new
		@title=full_title(setup_title)
		@coldstorage=ColdStorage.new
	end
	
	def create
		@title=full_title(setup_title)
		@coldstorage=ColdStorage.new
		if params[:howmany] > 0						
			@coldstorage=ColdStorage.new(params[:password],params[:howmany])
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
		send_data(inject_css(render_to_string), :filename => "colds.html") if @download=='plaintext'
		send_data(encrypt_my_page(inject_css(render_to_string),password), :filename => "cold.html.aes") if @download=='encrypted'
  end

  def public
  	@title=public_title
  end

  private

  def address_params
    params.require(:address).permit(:howmany, :password)
  end

  def clear_cache
  	Rails.cache.clear unless howmany > 0
  end

end
