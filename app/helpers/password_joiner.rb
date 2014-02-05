class PasswordJoiner
	include SecretSharingHelper
	attr_reader :password

	def initialize(string)
		raise 'Cannot Join an empty string' if string.blank?
		shares=string.split(/\s+/)
		k=shares.length
		raise "The string #{string} seems to have only #{k} shares which are not enough" unless k>1
		shamir=SecretSharing::Shamir.new(k)
		shares.each do |share|
			shamir << share if shamir.secret.nil?
		end
		@password=int_string_to_string(shamir.secret.to_s) unless shamir.secret.nil?
	end

end
