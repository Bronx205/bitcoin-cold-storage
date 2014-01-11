module AddressesHelper
	
	require 'bitcoin'
	require 'rqrcode'

	def generate_qr(string)
		RQRCode::QRCode.new( string, :size => 6, :level => :h )		
	end	

	private

		def generate_addresses_array(array_size)
			result=[]
			(0..array_size-1).each do |counter|
				temp={}
				key = Bitcoin::Key.generate
				temp[:addr] = key.addr
				temp[:pub] = key.pub
				temp[:private_wif] = key.to_base58
				result << temp
			end
			return result
		end


end


# address_hash[:qr_address] = RQRCode::QRCode.new( address_hash[:address], :size => 8, :level => :h )
# address_hash[:qr_prvkey] = RQRCode::QRCode.new( address_hash[:prvkey], :size => 8, :level => :h )

# def generate_address
#   prvkey, pubkey = generate_key
#   [ pubkey_to_address(pubkey), prvkey, pubkey, hash160(pubkey) ]
# end
