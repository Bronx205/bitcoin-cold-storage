module AddressesHelper
	require 'bitcoin'
	require 'rqrcode'


	# Bitcoin::Key.generate gives [k.priv, k.pub, k.addr, k.to_base58=Wallet import format]	

	# def generate_address_hash
	# 	address_hash={}
	# 	Key=Bitcoin::Key.generate
	# 	address_hash[:pubkey]=Key[2]
	# 	address_hash[:prvkey]=Key[1]
	# 	address_hash[:address]=Key[0]
	# 	return address_hash
	# end

	# def generate_addresses_array(array_size)
	# 	address_array=[]
	# 	(0..array_size-1).each do |counter|
	# 		address_hash=generate_address_hash
	# 		address_hash[:id]=counter
	# 		address_array<<address_hash
	# 	end
	# 	return address_array
	# end

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

		# address_hash[:qr_address] = RQRCode::QRCode.new( address_hash[:address], :size => 8, :level => :h )
		# address_hash[:qr_prvkey] = RQRCode::QRCode.new( address_hash[:prvkey], :size => 8, :level => :h )

	# def generate_address
	#   prvkey, pubkey = generate_key
	#   [ pubkey_to_address(pubkey), prvkey, pubkey, hash160(pubkey) ]
	# end

end
