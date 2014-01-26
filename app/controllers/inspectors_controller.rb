class InspectorsController < ApplicationController
  def new
  	@title=inspect_title
  end

  def create
    @file=params[:file]
    @title=inspect_title
    case @file.original_filename[-3..-1]
    when 'csv'
      @csv_data=CSV.read(@file.path)
      # binding.pry      
      case @csv_data[0].length
      when 2
        if addresses_csv_format?(@csv_data)
          @keys=build_addresses_hash_array(@csv_data)
          @title=addresses_title
          render 'addresses'          
        else
          flash[:error] = incorrect_format_flash
          render 'new'
        end
      when 3
        @keys=build_private_keys_hash_array(@csv_data)
        @title=private_keys_title
        render 'private_keys'        
      end
    else
      flash[:error] = upload_format_error
      render 'new'
    end
  end

end
