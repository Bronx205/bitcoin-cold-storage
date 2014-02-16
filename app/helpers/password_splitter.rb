class PasswordSplitter
	require 'shamir-secret-sharing'
	attr_reader :k, :n, :shares

	def initialize(n=5,k=3,password=PasswordGenerator.new.password)
		@password=password
		@k=k
		@n=n
		@shares=ShamirSecretSharing::Base58.split(secret=@password, available=@n, needed=@k)
	end

end
