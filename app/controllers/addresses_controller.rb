class AddressesController < ApplicationController
	require 'rqrcode'

  def new
		@title=full_title(setup_title)
		@coldstorage=ColdStorage.new
	end
	
	def create
		@title=full_title(setup_title)
		@coldstorage=ColdStorage.new
		if params[:howmany].to_i > 0						
			@coldstorage=ColdStorage.new(params[:password],params[:howmany])
			flash[:var]=@coldstorage
			Rails.cache.clear
			redirect_to private_path 
		else
			render 'new'
		end
	end
  
  def private
  	@title=private_title
		@coldstorage=flash[:var]
		flash[:var]=@coldstorage		
		if @coldstorage.nil?
			redirect_to root_path 
		else
			@addresses=@coldstorage.addresses
			@howmany=@coldstorage.howmany
			@password=@coldstorage.password
			@entropy=@coldstorage.entropy
			@download=params[:download]
			send_data(inject_css(render_to_string), :filename => "colds.html") if @download=='plaintext'
			send_data(encrypt_my_page(inject_css(render_to_string),password), :filename => "cold.html.aes") if @download=='encrypted'
		end
  end

  def public
  	@title=public_title
  end

  private

  def address_params
    params.require(:address).permit(:howmany, :password)
  end

end
