class AddressesController < ApplicationController
	require 'rqrcode'

  def new
		@title=full_title(setup_title)
		# @coldstorage=ColdStorage.new
	end
	
	def create
		@title=full_title(setup_title)
		@coldstorage=ColdStorage.new
		if params[:howmany].to_i > 0						
			@coldstorage=ColdStorage.new(params[:password],params[:howmany])
			flash[:var]=@coldstorage
			Rails.cache.clear
			redirect_to view_path 
		else
			render 'new'
		end
	end
  
  def show
  	@title=view_title
		@coldstorage=flash[:var]
		# flash[:var]=@coldstorage		
		if @coldstorage.nil?
			redirect_to root_path 
		else
			@addresses=@coldstorage.addresses
			@howmany=@coldstorage.howmany
			@password=@coldstorage.password
			@entropy=@coldstorage.entropy
			@alphabet=@coldstorage.alphabet
			@explanation=entropy_explanation(@password.length, @alphabet,@entropy)
			html=render_to_string
			plaintext=inject_css(html)
			encrypted=encrypt_my_page(plaintext,@password)
			save_coldstorage_files(plaintext,encrypted)
		end
  end

  private

  def address_params
    params.require(:address).permit(:howmany, :password)
  end

end
