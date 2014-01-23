class FreezersController < ApplicationController
	require 'rqrcode'
	
	before_filter :clear_flash_messages
	before_filter	:clear_cache,							only: [:create]
	before_filter	:redirect_home,						only: [:addresses, :private_keys]

  def new
		@title=full_title(freeze_title)
		flash[:new] = false
	end
	
	def create
		@title=full_title(freeze_title)		
		howmany=params[:howmany].to_i
		if (1..KEYS_LIMIT).include?(howmany)
			@qm=Quartermaster.new(KeyGenerator.new(howmany).keys)	
			@qm.dump_files
			@password=set_password(params[:password])			
			flash[:password]=password_message(@password,@password==params[:password])
			redirect_to private_keys_path 
		else
			flash.now[:error] = addresses_range_notice
			render 'new'
		end
	end

  def addresses
  	redirect_to root_path unless File.exist?(public_addresses_file_path('csv'))
  	@title=addresses_title
    @data=CSV.read(public_addresses_file_path('csv'))
    @keys=build_addresses_hash_array(@data)
  end

  def private_keys
  	@title=private_keys_title
    @data=CSV.read(private_keys_file_path('csv',false))
    @keys=build_private_keys_hash_array(@data)
  end

  def download_plain
  	@data=CSV.read(private_keys_file_path('csv',false))
  	send_data @data,
  	filename: private_keys_file_name+'.csv'
  end

  private

	  def freezers_params
	    params.require(:keys).permit(:howmany, :password)
	  end

		def set_password(string)
			return PasswordGenerator.new.password if string.blank?
			string.to_s
		end

	  def clear_flash_messages
	  	flash[:error].clear if flash[:error] 
	  end	

	  def clear_cache
	  	Rails.cache.clear
	  end

	  def redirect_home
	  	redirect_to root_path unless files_exist?
	  end

	  def files_exist?
	  	File.exist?(public_addresses_file_path('csv')) && File.exist?(private_keys_file_path('csv',false))
	  end
end

# send_data(inject_css(render_to_string), :filename => "colds.html") if @download=='plaintext'
# send_data(encrypt_my_page(inject_css(render_to_string),@password), :filename => "cold.html.aes") if @download=='encrypted'

  # def show
  # 	@title=cold_view_title  	
		# @coldstorage=Rails.cache.read(:cold)
		# if @coldstorage.nil? || !flash[:new]
		# 	redirect_to root_path 
		# else
		# 	@keys=@coldstorage.keys
		# 	@howmany=@coldstorage.howmany
		# 	@password=@coldstorage.password
		# 	@entropy=PasswordGenerator.new.calculate_entropy(@password)
		# 	@alphabet=PasswordGenerator.new.alphabet
		# 	@explanation=entropy_explanation(@password.length, @alphabet,@entropy)
		# 	html=render_to_string
		# 	plaintext=inject_css(html)
		# 	encrypted=encrypt_my_file(plaintext,@password)
		# 	save_full_html(plaintext,encrypted)
		# 	# send_data('foo', filename: 'foo.txt')
		# end
  # end