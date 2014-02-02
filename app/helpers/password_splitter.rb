class PasswordSplitter

	attr_reader :password, :k, :n, :shares

	def initialize(n=5,k=3,password=PasswordGenerator.new.password)
		@password=password
		@k=k
		@n=n
		@Shamir=SecretSharing::Shamir.new(n,k)
	end

	

end
