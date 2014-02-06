class PasswordJoiner
	include SecretSharingHelper
	attr_reader :password

	def initialize(string)
		shares=string.split(/\s+/)
		k=shares.length
		raise 'The minimal number of shares is 2' if k<2
		shamir=SecretSharing::Shamir.new(k)
		shares.each do |share|
			shamir << share if shamir.secret.nil?
		end
		@password=int_string_to_string(shamir.secret.to_s) unless shamir.secret.nil?		
	end

end
