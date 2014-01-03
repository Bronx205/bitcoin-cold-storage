class AddressesController < ApplicationController
	require 'rqrcode'
	include AddressesHelper
  
  def private
  	@title=private_title
		@howmany=cookies[:howmany].to_i
		@howmany||=1
		redirect_to root_path unless @howmany > 0
		@addresses=generate_addresses_array(@howmany)
		@download=params[:download]				
		send_data(render_to_string, :filename => "coldstorage.html") if @download

  end

  def public
  end
end
