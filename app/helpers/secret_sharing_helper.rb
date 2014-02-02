module SecretSharingHelper
	
require 'secretsharing'

	def string_to_int_string(string)
		temp=string.bytes.map do |byte|
			if (10..99).include?(byte)
				'0'<<byte.to_s
			elsif (0..9).include?(byte)
				'00'<<byte.to_s
			else
				byte.to_s
			end
		end
		temp.unshift('100').join
	end

	def int_string_to_string(int_string)
		raise int_string + 'is not an int string' unless int_string?(int_string)
		int_string.scan(/\d{3}/).map(&:to_i).drop(1).pack('c*')
	end

	def int_string?(string)
		return false unless (string.length)%3 == 0
		# string.each_char do |char|
		# 	return false unless ('0'.ord..'9'.ord).include?(char.ord)
		# end		
		string.match(/^\d*$/)[0] == string
	end
end

# # create an object for 3 out of 5 secret sharing
# s = SecretSharing::Shamir.new(5,3)

# # create a random secret (returns the secret)
# s.create_random_secret()
# # or set your own using some big number
# s.set_fixed_secret('23412395234756928375892347') 
# # show secret
# puts s.secret

# # show password representation of secret (Base64)
# puts s.secret_password

# # show shares
# s.shares.each { |share| puts share }

# # recover secret from shares

# s2 = SecretSharing::Shamir.new(3)
# # accepts SecretSharing::Shamir::Share objects or
# # string representations thereof
# s2 << s.shares[0]
# s2 << s.shares[2]
# s2 << s.shares[4]
# puts s2.secret

# 'foo'.bytes

# b=a.map do |x|
#   if x<100
#     10*x
#   else  
#     x
#   end  
# end  
