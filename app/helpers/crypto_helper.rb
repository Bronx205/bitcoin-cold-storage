module CryptoHelper

	def encrypt(string,password)
		AESCrypt.encrypt(string,password)
	end

	def decrypt(string,password)
		AESCrypt.decrypt(string,password)
	end	

end