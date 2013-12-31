class AddressesController < ApplicationController
	require 'rqrcode'
	include AddressesHelper
  
  def private
		@key = Bitcoin::generate_key
		@address = Bitcoin::pubkey_to_address(@key[1])  	
		@qr = RQRCode::QRCode.new( @address, :size => 3, :level => :l )
  end

  def public
  end
end
