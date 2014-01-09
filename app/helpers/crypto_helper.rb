module CryptoHelper

	def encrypt_my_page(page,password=generate_strong_password)
		AESCrypt.encrypt(page,password)
	end

	def generate_strong_password(howlong=30)
		result=""
		while result.length < howlong
			kind=meta_array.sample						
			temp=kind.sample
			result<<temp if result.index(temp).nil? && kind.index(result[-1]).nil?
		end
		result
	end

	private

	def lower_array
		("a".."z").to_a 	 	
	end

	def upper_array
		("A".."Z").to_a 	 	
	end

	def digit_array
		("0".."9").to_a
	end

	def char_array
		"!@#$%^&*+~".split("")
	end

	def meta_array
		[]<<lower_array<<upper_array<<digit_array<<char_array
	end

end