class OvensController < ApplicationController

  def new
  	@title=heatup_title
  end

  def create
    @title=heatup_title
  	@password=params[:recover_password]
    flash[:hot]=@password
    redirect_to hot_view_path
  end

  def show
  	@title=hot_view_title
    @password=flash[:hot]
    @page=decrypt_loaded(@password)  	
  end
end
