module CryptoHelper

	def encrypt(file,password)
		AESCrypt.encrypt(file,password)
	end

	def decrypt(file,password)
		AESCrypt.decrypt(file,password)
	end	

end