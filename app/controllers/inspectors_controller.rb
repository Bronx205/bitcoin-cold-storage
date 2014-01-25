class InspectorsController < ApplicationController
  def new
  	@title=inspect_title
  end

  def create
  	@csv_file=params[:csv].read
  	
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
