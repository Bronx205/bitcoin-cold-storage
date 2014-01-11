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
		flash[:var]=@coldstorage		
		if @coldstorage.nil?
			redirect_to root_path 
		else
			@addresses=@coldstorage.addresses
			@howmany=@coldstorage.howmany
			@password=@coldstorage.password
			@entropy=@coldstorage.entropy
			@download=params[:download]
			html=render_to_string
			plaintext=inject_css(html)
			encrypted=encrypt_my_page(plaintext,@password)
			File.open("/home/assaf/Downloads/plaintext.html", "w") { |file| file.write plaintext }
			File.open("/home/assaf/Downloads/encrypted.html.aes", "w") { |file| file.write encrypted }
			send_data(plaintext, :filename => "colds.html") if @download=='plaintext'
			send_data(encrypted, :filename => "cold.html.aes") if @download=='encrypted'
		end
  end

  private

  def address_params
    params.require(:address).permit(:howmany, :password)
  end

end
