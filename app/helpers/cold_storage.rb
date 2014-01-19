class ColdStorage
	
	require 'bitcoin'
	include CryptoHelper
	include FreezersHelper

	attr_reader :user_password, :howmany, :strong_password, :keys

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

	def entropy
		@password_generator.calculate_entropy(password)
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
