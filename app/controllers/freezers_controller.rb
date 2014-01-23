class FreezersController < ApplicationController
	require 'rqrcode'
	
	before_filter :clear_flash_messages

  def new
		@title=full_title(freeze_title)
		flash[:new] = false
	end
	
	def create
		@title=full_title(freeze_title)		
		howmany=params[:howmany].to_i
		if howmany > 0 && howmany < ColdStorage.keys_limit+1		
			@qm=Quartermaster.new(KeyGenerator.new(howmany).keys)	
			@qm.dump_files
			flash[:password]=password_flash_prefix+params[:password]+password_flash_suffix
			@coldstorage=ColdStorage.new(howmany,params[:password])			
			Rails.cache.clear
			Rails.cache.write(:cold, @coldstorage, expires_in: howmany.minute )
			flash[:new]=true
			redirect_to private_keys_path 
		else
			flash.now[:error] = addresses_range_notice
			render 'new'
		end
	end
  
  def show
  	@title=cold_view_title  	
		@coldstorage=Rails.cache.read(:cold)
		if @coldstorage.nil? || !flash[:new]
			redirect_to root_path 
		else
			@keys=@coldstorage.keys
			@howmany=@coldstorage.howmany
			@password=@coldstorage.password
			@entropy=PasswordGenerator.new.calculate_entropy(@password)
			@alphabet=PasswordGenerator.new.alphabet
			@explanation=entropy_explanation(@password.length, @alphabet,@entropy)
			html=render_to_string
			plaintext=inject_css(html)
			encrypted=encrypt_my_file(plaintext,@password)
			save_full_html(plaintext,encrypted)
			# send_data('foo', filename: 'foo.txt')
		end
  end

  def addresses
  	@title=addresses_title
    @data=CSV.read(public_addresses_file_path('csv'))
    @keys=build_addresses_hash_array(@data)
  end

  def private_keys
  	@title=private_keys_title
    @data=CSV.read(private_keys_file_path('csv',false))
    @keys=build_private_keys_hash_array(@data)
  end

  private

	  def freezers_params
	    params.require(:keys).permit(:howmany, :password)
	  end

end

# send_data(inject_css(render_to_string), :filename => "colds.html") if @download=='plaintext'
# send_data(encrypt_my_page(inject_css(render_to_string),@password), :filename => "cold.html.aes") if @download=='encrypted'