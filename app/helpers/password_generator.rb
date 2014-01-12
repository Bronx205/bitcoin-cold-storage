class PasswordGenerator

	attr_reader :password

	def initialize(length=30)
		@password=generate_strong_password(length)
	end

	def self.alphabet
		meta_array.flatten.join('')
	end

	def self.calculate_entropy(string,alphabet=self.alphabet)
		return -1 unless self.in_alphabet?(string,alphabet)
		string.length * Math.log(alphabet.length,2)
	end

	def entropy
		PasswordGenerator.calculate_entropy(@password)
	end

	private

	def generate_strong_password(howlong=30)
		result=""
		while result.length < howlong
			kind=PasswordGenerator.meta_array.sample						
			temp=kind.sample
			result<<temp if result.index(temp).nil? && kind.index(result[-1]).nil?
		end
		result
	end

	def self.lower_array
		("a".."z").to_a 	 	
	end

	def self.upper_array
		("A".."Z").to_a 	 	
	end

	def self.digit_array
		("0".."9").to_a
	end

	def self.char_array
		"!@#$%^&*+~".split("")
	end

	def self.meta_array
		[]<<lower_array<<upper_array<<digit_array<<char_array
	end

	def self.in_alphabet?(string,alphabet=self.alphabet)
		alphabet_array=alphabet.split('')
		string.each_char do |char|
			return false unless alphabet_array.include?(char)
		end
		true
	end
end
