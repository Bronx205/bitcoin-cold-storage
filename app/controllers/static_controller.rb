class StaticController < ApplicationController
  
  before_filter :set_global_vars

  def home
  	@title='Home'
  end

  def help
  	@title='Help'
  end

  def about
  	@title='About'
  end

end
