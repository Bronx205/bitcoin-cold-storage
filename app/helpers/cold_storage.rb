class ColdStorage
	
	require 'bitcoin'
	include CryptoHelper

	attr_reader :howmany, :keys

	def initialize(howmany,user_password='')
		@howmany = set_number(howmany)
		raise 'ColdStorage must initialize with a positive integer' unless @howmany > 0
		@keys=generate_keys_array(@howmany)
		@user_password = user_password.to_s
		@strong_password=PasswordGenerator.new.password		
	end

	def password
		if @user_password.blank?
			@strong_password
		else
			@user_password
		end
	end

	def self.keys_limit
		25
	end

	private

		def set_number(number)
			@howmany=[number.to_i,0].max
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