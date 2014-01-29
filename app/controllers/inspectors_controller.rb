class InspectorsController < ApplicationController
  
  def new
  	@title=inspect_page_title
  end

  def create    
    @title=inspect_page_title
    process_uploaded_file(params[:file],params[:password])
  end

  def addresses
  	@title = addresses_title
  	@keys = flash[:keys]
  end

  def private_keys
  	@title = private_keys_title
  	@keys = flash[:keys]
  end

  private

    def process_uploaded_file(file,password)
      case file.original_filename[-3..-1]
      when 'csv'
        process_csv(file)
      when 'aes'
        process_aes(file,password)
      else
        flash[:error] = upload_format_error
        redirect_to inspect_path
      end   
    end

    def process_csv(file)
      csv_data=CSV.read(file.path)
      address_or_key(csv_data)    
    end

    def process_aes(file,password)
      encrypted_data=File.read(file.path)
      begin
        decrypted_data=JSON.parse decrypt(encrypted_data,password)
      rescue
        flash[:error] = wrong_password_flash
        redirect_to inspect_path
      else
        address_or_key(decrypted_data)      
      end    
    end

    def address_or_key(csv_data)    
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
        flash[:keys] = @keys
        redirect_to inspect_addresses_path
      else
        flash[:error] = incorrect_format_flash
        redirect_to inspect_path
      end    
    end

    def process_private_keys(csv_data)
      if private_keys_csv_format?(csv_data)
        @keys=build_private_keys_hash_array(csv_data)
        flash[:keys] = @keys
        redirect_to inspect_keys_path
      else
        flash[:error] = incorrect_format_flash
        redirect_to inspect_path
      end
    end  

end
