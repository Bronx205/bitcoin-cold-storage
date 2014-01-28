class InspectorsController < ApplicationController
  
  def new
  	@title=inspect_title
  end

  def create
    @file=params[:file]
    @title=inspect_title
    @password=params[:password]
    process_file(@file,@password)
  end




  private

  def process_file(file,password)
    case file.original_filename[-3..-1]
    when 'csv'
      csv_data=CSV.read(file.path)
      process_csv(csv_data)
    when 'aes'
      encrypted_data=File.read(file.path)
      decrypted_data=JSON.parse decrypt(encrypted_data,password)
      process_csv(decrypted_data)
    else
      flash[:error] = upload_format_error
      redirect_to inspect_path
    end   
  end

  def process_csv(csv_data)    
    case csv_data[0].length
    when 2
      process_addresses(csv_data)
    when 3
      process_private_keys(csv_data)    
    else
      flash[:error] = incorrect_format_flash
      redirect_to inspect_path        
    end   
  end

  def process_addresses(csv_data)
    if addresses_csv_format?(csv_data)
      @keys=build_addresses_hash_array(csv_data)
      @title=addresses_title
      render 'addresses'          
    else
      flash[:error] = incorrect_format_flash
      redirect_to inspect_path
    end    
  end

  def process_private_keys(csv_data)
    if private_keys_csv_format?(csv_data)
      @keys=build_private_keys_hash_array(csv_data)
      @title=private_keys_title
      render 'private_keys'          
    else
      flash[:error] = incorrect_format_flash
      redirect_to inspect_path
    end
  end





end
