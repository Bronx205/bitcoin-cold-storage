class PasswordGenerator

	attr_reader :password

	def initialize(length=30)
		@password=generate_strong_password(length)
	end

	def alphabet
		meta_array.flatten.join('')
	end

	def in_alphabet?(string,alphabet=alphabet)
		alphabet_array=alphabet.split('')
		string.each_char do |char|
			return false unless alphabet_array.include?(char)
		end
		true
	end	

	def calculate_entropy(string)
		return -1 unless in_alphabet?(string)
		string.length * Math.log(alphabet.length,2)
	end

	def entropy
		calculate_entropy(@password)
	end

	def meta_array
		[]<<lower_array<<upper_array<<digit_array<<char_array
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

		def generate_strong_password(howlong=30)
			result=""
			while result.length < howlong
				kind=meta_array.sample						
				temp=kind.sample
				result<<temp if result.index(temp).nil? && kind.index(result[-1]).nil?
			end
			result
		end

end
