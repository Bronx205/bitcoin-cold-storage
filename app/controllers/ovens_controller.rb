class OvensController < ApplicationController
  def new
  	@title=heatup_title
  end

  def create
  	
  end

  def show
  	@title=hot_view_title
  	
  end
end
