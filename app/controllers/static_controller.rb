class StaticController < ApplicationController
	before_filter :set_env

  def home
  	@title='Home'
  end

  def help
  	@title='Help'
  end

  def about
  	@title='About'
  end

  private

  	def set_env
  		$env ||= `hostname`[0..-2]
  	end
end
