class InspectorsController < ApplicationController
  def new
  	@title=inspect_title
  end

  def create
    @file=params[:file]
    # binding.pry

    case @file.original_filename[-3..-1]
    when 'csv'
      @csv_data=CSV.read(@file.path)
      @keys=build_addresses_hash_array(@csv_data)
      @title=addresses_title
      render 'addresses'
    else
      flash[:error] = upload_format_error
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
end
