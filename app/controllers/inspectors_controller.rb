class InspectorsController < ApplicationController
  def new
  	@title=inspect_title
  end

  def create
    @file=params[:file]
    case @file.original_filename[-3..-1]
    when 'csv'
      @csv_data=CSV.read(@file.path)
      case @csv_data[0].length
      when 2
        @keys=build_addresses_hash_array(@csv_data)
        @title=addresses_title
        render 'addresses'
      when 3
        @keys=build_private_keys_hash_array(@csv_data)
        @title=private_keys_title
        render 'private_keys'        
      end
    else
      flash[:error] = upload_format_error
    end
  end

end
