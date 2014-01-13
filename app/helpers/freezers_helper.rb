module FreezersHelper
	
	require 'bitcoin'
	require 'rqrcode'

	def generate_qr(string)
		RQRCode::QRCode.new( string, :size => 6, :level => :h )		
	end	

	def save_file(path, data)
		File.open(path,'w') {|file| file.write data }
	end

	def save_coldstorage_files(plain_file,encrypted_file)
		save_file(plaintext_file_path,plain_file)
		save_file(encrypted_file_path,encrypted_file)
	end

	def coldstorage_directory
		# '/home/assaf/Downloads/'
		File.expand_path(Rails.root)+ '/tmp/cold/'
	end

	def plaintext_file_name
		'plaintext.html'
	end

	def encrypted_file_name
		'coldstorage.html.aes'
	end

	def plaintext_file_path
		coldstorage_directory+plaintext_file_name
	end

	def encrypted_file_path
		coldstorage_directory+encrypted_file_name
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
