class StaticController < ApplicationController
	# before_filter :clear_flash_messages

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
