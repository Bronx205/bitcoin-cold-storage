class FreezersController < ApplicationController
	require 'rqrcode'
	
	before_filter :clear_flash_messages

  def new
		@title=full_title(freeze_title)
		flash[:new] = false
	end
	
	def create
		@title=full_title(freeze_title)
		@coldstorage=ColdStorage.new
		howmany=params[:howmany].to_i
		if howmany > 0						
			@coldstorage=ColdStorage.new(params[:password],howmany)			
			Rails.cache.clear
			Rails.cache.write(:cold, @coldstorage, expires_in: howmany.minute )
			flash[:new]=true
			redirect_to cold_view_path 
		else
			render 'new'
		end
	end
  
  def show
  	@title=cold_view_title  	
		@coldstorage=Rails.cache.read(:cold)
		if @coldstorage.nil? || !flash[:new]
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
			encrypted=encrypt_my_file(plaintext,@password)
			save_coldstorage_files(plaintext,encrypted)
		end
  end

  private

	  def address_params
	    params.require(:address).permit(:howmany, :password)
	  end

end
