class AddressesController < ApplicationController
	require 'rqrcode'
	include AddressesHelper
  
  def private
  	@title=private_title
		@key = Bitcoin::generate_key
		@address = Bitcoin::pubkey_to_address(@key[1])  	
		@qr = RQRCode::QRCode.new( @address, :size => 8, :level => :h )		
		@howmany=cookies[:howmany].to_i
		# @addresses=generate_addresses_array(@howmany)
  end

  def public
  end
end
