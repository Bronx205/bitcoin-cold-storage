module SecretSharingHelper
	
require 'secretsharing'

	def string_to_int(string)
		
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
