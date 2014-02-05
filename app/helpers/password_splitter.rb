class PasswordSplitter
	include SecretSharingHelper
	attr_reader :password, :k, :n, :shares

	def initialize(n=5,k=3,password=PasswordGenerator.new.password)
		@password=password
		@k=k
		@n=n
		shamir=SecretSharing::Shamir.new(n,k)
		shamir.set_fixed_secret(string_to_int_string(@password))
		@shares=shamir.shares.map(&:to_s)
	end

	def join(k,string)
		shares=string.split(/\s+/)
		raise 'Not enough shares' if shares.length < k
		shamir=SecretSharing::Shamir.new(k)
		shares.each do |share|
			shamir << share if shamir.secret.nil?
		end
		int_string_to_string(shamir.secret.to_s) unless shamir.secret.nil?
	end



end
