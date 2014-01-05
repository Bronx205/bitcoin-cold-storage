module AddressesHelper
	require 'bitcoin'
	require 'rqrcode'

	def set_amount(amount=1)
		self.howmany=[amount.to_i,1].max
	end

	def howmany=(int)
		@howmany=[int,1].max
		cookies[:howmany]=@howmany
	end

	def howmany
		@howmany=[cookies[:howmany].to_i,1].max 		
	end

	def generate_addresses_array(array_size)
		address_array=[]
		(0..array_size-1).each do |counter|
			address_array << Bitcoin::Key.generate
		end
		return address_array
	end

	def generate_qr(string)
		RQRCode::QRCode.new( string, :size => 8, :level => :h )		
	end

end


# address_hash[:qr_address] = RQRCode::QRCode.new( address_hash[:address], :size => 8, :level => :h )
# address_hash[:qr_prvkey] = RQRCode::QRCode.new( address_hash[:prvkey], :size => 8, :level => :h )

# def generate_address
#   prvkey, pubkey = generate_key
#   [ pubkey_to_address(pubkey), prvkey, pubkey, hash160(pubkey) ]
# end
