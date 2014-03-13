class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  include ViewsHelper
  include CryptoHelper
  include QrHelper
  include FreezersHelper
  include PathHelper
  include FilesHelper
  include DataHelper
  include InspectorsHelper

  def set_global_vars
    set_env
    set_tag
  end

  private

    def set_env
      $env ||= `hostname`[0..-2]      
    end

    def set_tag
      if Rails.env=='test'
        $tag='_test'
      elsif Rails.env=='development'
        $tag='_dev'
      elsif Rails.env=='production' && session.id.to_s.length>0  
        $tag='_'+session.id.to_s 
      else
        $tag=''
      end
    end

end
