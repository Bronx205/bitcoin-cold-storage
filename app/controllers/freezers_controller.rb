class FreezersController < ApplicationController
	require 'rqrcode'
	
	before_filter :set_global_vars
	before_filter :clear_flash_messages
	before_filter	:redirect_home,						only: [:addresses, :private_keys]

  def new
		@title=freeze_page_title		
	end
	
	def create
		@title=freeze_page_title
		howmany=params[:howmany].to_i
		$ssss={n: params[:ssss_n].to_i,k: params[:ssss_k].to_i}
		if valid_params?(howmany,$ssss) 
			password=set_password(params[:password])			
			keys=KeyGenerator.new(howmany).keys			
			@qm=Quartermaster.new(keys,password,$ssss)			
			@qm.dump_files
			flash[:password]=password_message(password,password==params[:password])			
			redirect_to new_keys_path 
		else
			flash.now[:error] = build_validation_message(howmany,$ssss)			
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

  def download
  	begin
  		if $env=='raspberrypi' || $env=='Dev'
  			copy_files
  		else
  			download_files
  		end
	  	# case params[:download]
	  	# when 'addresses'
		  # 	# send_file public_addresses_file_path('csv',$tag), filename: public_addresses_file_name+".csv"
		  # 	# FileUtils.cp(public_addresses_file_path('csv',$tag),'/media/coldstorage')
		  # 	FileUtils.cp_r(public_directory_path,'/media/coldstorage')
		  # 	flash[:success] = "Successfully copied addresses file..."
		  # 	redirect_to new_keys_path
		  # when 'unencrypted_private_keys'
		  # 	# send_file private_keys_file_path('csv',false,$tag), filename: private_keys_file_name+".csv"
		  # 	FileUtils.cp(private_keys_file_path('csv',false,$tag),'/media/coldstorage/PRIVATE/NON-ENCRYPTED')
		  # 	flash[:danger] = "Successfully copied UNENCRYPTED private keys file..."
		  # 	redirect_to new_keys_path		  	
		  # when 'encrypted_private_keys'
		  # 	# send_file private_keys_file_path('csv',true,$tag), filename: private_keys_file_name+".csv.aes"
		  # 	FileUtils.cp_r(private_keys_file_path('csv',true,$tag),'/media/coldstorage/PRIVATE/encrypted')
		  # 	flash[:danger] = "Successfully copied encrypted private keys file..."
		  # 	redirect_to new_keys_path				  	
		  # when 'password_share'
		  # 	# send_file password_shares_path(params[:share].to_i,$tag), filename: password_share_file_name+'_'+params[:share]+'.csv'
		  # 	FileUtils.cp_r(password_shares_path(params[:share].to_i,$tag),'/media/coldstorage/PRIVATE/encrypted')
		  # 	flash[:danger] = "Successfully copied password share #" + params[:share].to_i.to_s + " file..."
		  # 	redirect_to new_keys_path			  	
		  # else
		  # 	render 'addresses'
		  # end
		rescue ActionController::MissingFile
			flash[:error]= missing_file_error
			redirect_to root_path
		end
  end


  private

  	def copy_files
	  	case params[:download]
	  	when 'addresses'
		  	FileUtils.cp_r(public_directory_path,'/media/coldstorage')
		  	flash[:success] = "Successfully copied " + public_addresses_file_name + " file to external drive"
		  when 'unencrypted_private_keys'
		  	FileUtils.cp(private_keys_file_path('csv',false),'/media/coldstorage/PRIVATE/NON-ENCRYPTED')
		  	flash[:danger] = "Successfully copied UNENCRYPTED " + private_keys_file_name + " file to external drive"
		  when 'encrypted_private_keys'
		  	FileUtils.cp(private_keys_file_path('csv',true),'/media/coldstorage/PRIVATE/encrypted')
		  	flash[:success] = "Successfully copied encrypted " + private_keys_file_name + " file to external drive"
		  when 'password_share'
		  	FileUtils.cp(password_shares_path(params[:share].to_i),'/media/coldstorage/PRIVATE/encrypted')
		  	flash[:success] = "Successfully copied "+ password_share_file_name + " #" + params[:share].to_i.to_s + " file to external drive"
		  else
		  	redirect_to root_path
		  end  		
		  redirect_to new_keys_path			  	
  	end

  	def download_files
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
		  	redirect_to root_path
		  end 		
  	end

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
	  	redirect_to root_path unless all_files_there?
	  end

	  def build_validation_message(howmany,ssss_hash)
	  	message=""
	  	message << addresses_range_notice + ". " unless (1..KEYS_LIMIT).include?(howmany)
	  	message << at_least_two_shares_flash + ". " unless (2..SHARES_LIMIT).include?(ssss_hash[:n]) && (2..SHARES_LIMIT).include?(ssss_hash[:k])
	  	message << k_not_smaller_than_n_flash + ". " unless ssss_hash[:k]<ssss_hash[:n]
	  	return message
	  end
	  def valid_params?(howmany,ssss_hash)
	  	(1..KEYS_LIMIT).include?(howmany) && (2..SHARES_LIMIT).include?(ssss_hash[:n]) && (2..SHARES_LIMIT).include?(ssss_hash[:k]) && ssss_hash[:k]<ssss_hash[:n]
	  end

end