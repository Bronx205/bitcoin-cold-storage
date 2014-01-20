class ColdStorage
	
	require 'bitcoin'
	include CryptoHelper

	attr_reader :howmany, :keys

	def initialize(user_password='',howmany=0)
		@user_password = set_password(user_password)
		@howmany = set_number(howmany)
		@password_generator=PasswordGenerator.new
		@strong_password=@password_generator.password
		@keys=generate_keys_array(@howmany)
	end

	def password
		if @user_password.blank?
			@strong_password
		else
			@user_password
		end
	end

	def keys_limit
		25
	end

	private

		def set_number(number)
			@howmany=[number.to_i,0].max
		end
		def set_password(string)
			@user_password=string.to_s
		end
		def generate_keys_array(array_size)
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
# def generate_address
#   prvkey, pubkey = generate_key
#   [ pubkey_to_address(pubkey), prvkey, pubkey, hash160(pubkey) ]
# end
# Bitcoin::Key.from_base58(key.to_base58).addr to retrieve an address from a private key