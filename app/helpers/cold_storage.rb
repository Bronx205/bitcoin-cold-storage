class ColdStorage
	include CryptoHelper
	include AddressesHelper
	attr_reader :user_password, :howmany, :strong_password, :addresses

	def initialize(user_password='',howmany=0)
		@user_password = set_password(user_password)
		@howmany = set_number(howmany)
		@password_generator=PasswordGenerator.new
		@strong_password=@password_generator.password
		@addresses=generate_addresses_array(@howmany)
		@@current_addresses=@addresses
	end

	def password
		if @user_password.blank?
			@strong_password
		else
			@user_password
		end
	end

	private
    def create_remember_token
	    self.remember_token = SecureRandom.urlsafe_base64          
    end	
		def set_number(number)
			@howmany=[number.to_i,0].max
		end
		def set_password(string)
			@user_password=string.to_s
		end

end
