class InspectorsController < ApplicationController
  def new
  	@title=inspect_title
  end

  def create
    @file=params[:file]
    @title=inspect_title
    process_file(@file)
  end




  private

  def inspect_addresses(csv_data)
    if addresses_csv_format?(csv_data)
      @keys=build_addresses_hash_array(csv_data)
      @title=addresses_title
      render 'addresses'          
    else
      flash[:error] = incorrect_format_flash
      redirect_to inspect_path
    end    
  end

  def inspect_private_keys(csv_data)
    if private_keys_csv_format?(csv_data)
      @keys=build_private_keys_hash_array(csv_data)
      @title=private_keys_title
      render 'private_keys'          
    else
      flash[:error] = incorrect_format_flash
      redirect_to inspect_path
    end
  end

  def process_csv(file)
    @csv_data=CSV.read(file.path)
    case @csv_data[0].length
    when 2
      inspect_addresses(@csv_data)
    when 3
      inspect_private_keys(@csv_data)    
    else
      flash[:error] = incorrect_format_flash
      redirect_to inspect_path        
    end   
  end

  def process_file(file)
    case file.original_filename[-3..-1]
    when 'csv'
      process_csv(file)
    else
      flash[:error] = upload_format_error
      redirect_to inspect_path
    end   
  end

end
