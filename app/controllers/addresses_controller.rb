class AddressesController < ApplicationController
	require 'rqrcode'
	include AddressesHelper
  
  def private
		@key = Bitcoin::generate_key
		@address = Bitcoin::pubkey_to_address(@key[1])  	
		@qr = RQRCode::QRCode.new( @address, :size => 8, :level => :h )
  end

  def public
  end
end
