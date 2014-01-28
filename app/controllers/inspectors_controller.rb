class InspectorsController < ApplicationController
  
  def new
  	@title=inspect_title
  end

  def create    
    @title=inspect_title
    process_uploaded_file(params[:file],params[:password])
  end

end
