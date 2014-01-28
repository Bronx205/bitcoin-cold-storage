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

end
