class OvensController < ApplicationController

  def new
  	@title=heatup_title      
  end

  def create
    @title=heatup_title
  	@password=params[:recover_password]
    flash[:hot]=@password
    begin
      @addresses=extract_addresses_html(decrypt_loaded(@password))
      redirect_to hot_view_path
    rescue
      flash.now[:error]=failed_decryption_message
      render 'new'
    end      
  end

  def show
  	@title=hot_view_title
    @password=flash[:hot]
    @addresses=extract_addresses_html(decrypt_loaded(@password))
  end

end
