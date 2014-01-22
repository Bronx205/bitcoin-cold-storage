class OvensController < ApplicationController

  def new
  	@title=heatup_title 
    unless file_there?(private_keys_file_path('html',true))
      flash[:error]=no_file_message
      redirect_to root_path
    end
  end

  def create
    @title=heatup_title
    @file=file_there?(private_keys_file_path('html',true))
  	@password=params[:recover_password]
    flash[:hot]=@password
    begin
      @keys=extract_keys_html(decrypt_loaded(@password))
      redirect_to hot_view_path
    rescue
      flash.now[:error]=failed_decryption_message
      render 'new'
    end      
  end

  def show
  	@title=hot_view_title
    @password=flash[:hot]
    @keys=extract_keys_html(decrypt_loaded(@password))
  end

  def addresses
    @data=CSV.read(public_addresses_file_path('csv'))
  end

end
