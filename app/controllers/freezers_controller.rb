class FreezersController < ApplicationController
	require 'rqrcode'
	
	before_filter :clear_flash_messages
	before_filter	:redirect_home,						only: [:addresses, :private_keys]

  def new
		@title=freeze_page_title
	end
	
	def create
		@title=freeze_page_title
		howmany=params[:howmany].to_i
		if (1..KEYS_LIMIT).include?(howmany)
			password=set_password(params[:password])			
			keys=KeyGenerator.new(howmany).keys
			$ssss={n: params[:ssss_n].to_i,k: params[:ssss_k].to_i}
			@qm=Quartermaster.new(keys,password,$ssss)			
			@qm.dump_files
			flash[:password]=password_message(password,password==params[:password])
			redirect_to new_keys_path 
		else
			flash.now[:error] = addresses_range_notice
			render 'new'
		end
	end

  def addresses  	
  	@expose=params[:expose]
  	@title=addresses_title
    @data=CSV.read(public_addresses_file_path('csv'))
    @keys=build_addresses_hash_array(@data)
  end

  def private_keys
  	@expose=params[:expose]
  	@n=$ssss[:n]
  	@title=private_keys_title
    @data=CSV.read(private_keys_file_path('csv',false))
    @keys=build_private_keys_hash_array(@data)
  end

  # def download_plain
  # 	@data=CSV.read(public_addresses_file_path('csv'))
  # 	send_data @data,
  # 	filename: public_addresses_file_path+'.csv'
  # end

  def download
  	begin
	  	case params[:download]
	  	when 'addresses'
		  	send_file public_addresses_file_path('csv'), filename: public_addresses_file_name+".csv"
		  when 'unencrypted_private_keys'
		  	send_file private_keys_file_path('csv',false), filename: private_keys_file_name+".csv"
		  when 'encrypted_private_keys'
		  	send_file private_keys_file_path('csv',true), filename: private_keys_file_name+".csv.aes"
		  when 'password_share'
		  	send_file password_shares_path(params[:share].to_i), filename: password_share_file_name+'_'+params[:share]+'.csv'
		  else
		  	render 'addresses'
		  end
		rescue ActionController::MissingFile
			flash[:error]= missing_file_error
			redirect_to root_path
		end
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
		# 	encrypted=encrypt(plaintext,@password)
		# 	save_full_html(plaintext,encrypted)
		# 	# send_data('foo', filename: 'foo.txt')
		# end
  # end