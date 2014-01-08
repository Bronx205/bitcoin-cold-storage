module AddressesHelper
	
	require 'bitcoin'
	require 'rqrcode'
	
	@@addresses_array=[]
	@@howmany=1	

	def set_amount(amount=1)
		@@howmany=[amount.to_i,1].max
	end

	def set_addresses_array
		self.addresses_array=generate_addresses_array(@@howmany)
	end

	def addresses_array
		@@addresses_array
	end

	def howmany
		@@howmany
	end

	def addresses_array=(array)
		@@addresses_array=array
	end

	def generate_qr(string)
		RQRCode::QRCode.new( string, :size => 8, :level => :h )		
	end	

	def register(coldstorage)
		cookies[:remember_token]=coldstorage.remember_token
		self.current_storage=coldstorage
	end

	# def signed_in?
	# 	!current_user.nil?
	# end

	# def current_user=(user)
	# 	@current_user=user
	# end

	# def current_user
	# 	@current_user ||=User.find_by_remember_token(cookies[:remember_token])		
	# end

	# def current_user?(user)
	# 	user==current_user		
	# end

	# def sign_out
	# 	self.current_user=nil # I don't think this is necessary
	# 	cookies.delete(:remember_token)		
	# end


	def current_storage=(coldstorage)
		@current_storage=coldstorage
	end

	def current_storage
		@cu
	end


	private

		def generate_addresses_array(array_size)
			temp=[]
			(0..array_size-1).each do |counter|
				temp << Bitcoin::Key.generate
			end
			return temp
		end


end


# address_hash[:qr_address] = RQRCode::QRCode.new( address_hash[:address], :size => 8, :level => :h )
# address_hash[:qr_prvkey] = RQRCode::QRCode.new( address_hash[:prvkey], :size => 8, :level => :h )

# def generate_address
#   prvkey, pubkey = generate_key
#   [ pubkey_to_address(pubkey), prvkey, pubkey, hash160(pubkey) ]
# end
