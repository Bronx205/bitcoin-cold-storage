module AddressesHelper
	require 'bitcoin'
	require 'rqrcode'


	def generate_address_hash
		address_hash={}
		address_array=Bitcoin::generate_address
		address_hash[:pubkey]=address_array[2]
		address_hash[:prvkey]=address_array[1]
		address_hash[:address]=address_array[0]
		address_hash[:qr_address] = RQRCode::QRCode.new( address_hash[:address], :size => 8, :level => :h )
		address_hash[:qr_prvkey] = RQRCode::QRCode.new( address_hash[:prvkey], :size => 8, :level => :h )
		return address_hash
	end

	def generate_addresses_array(array_size)
		address_array=[]
		(0..array_size-1).each do |counter|
			address_hash=generate_address_hash
			address_hash[:id]=counter
			address_array<<address_hash
		end
		return address_array
	end

	# def generate_address
	#   prvkey, pubkey = generate_key
	#   [ pubkey_to_address(pubkey), prvkey, pubkey, hash160(pubkey) ]
	# end
end
